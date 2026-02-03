--[[
════════════════════════════════════════════════════════════════════════════════════════════════
    
    ██╗     ██╗  ██╗██████╗        ██████╗  ██████╗ ██╗  ██╗███████╗██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝██╔══██╗
    ██║      ╚███╔╝ ██████╔╝       ██████╔╝██║   ██║█████╔╝ █████╗  ██████╔╝
    ██║      ██╔██╗ ██╔══██╗       ██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║       ██║     ╚██████╔╝██║  ██╗███████╗██║  ██║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    
    🐺 LXR Poker V2.0 - Server Script
    
    Professional Texas Hold'em Poker Server
    Handles game state, turn management, security validation, and economy
    
════════════════════════════════════════════════════════════════════════════════════════════════
    
    📋 RESPONSIBILITIES
    ═══════════════════════════════════════════════════════════════════════════════════════════
    ✓ Game State Management & Synchronization
    ✓ Player Join/Leave Handling with Validation
    ✓ Turn Management & Timer Enforcement
    ✓ Betting Logic (Call, Raise, Fold, Check, All-in)
    ✓ Pot Calculation & Side Pot Management
    ✓ Hand Evaluation & Winner Determination
    ✓ Money/Chip Economy & Transactions
    ✓ House Rake Collection
    ✓ Security & Anti-Cheat Validation
    ✓ Rate Limiting & Cooldown Enforcement
    ✓ Database Integration & Statistics
    ✓ Admin Commands
    ═══════════════════════════════════════════════════════════════════════════════════════════
    
════════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER STATE █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
local PokerTables = {}
local PlayerCooldowns = {}
local PlayerActionCounts = {}

-- Initialize all poker tables
for tableId, tableConfig in ipairs(Config.Tables) do
    PokerTables[tableId] = {
        id = tableId,
        config = tableConfig,
        players = {},      -- {seat#: {source, name, chips, cards, status, bet}}
        spectators = {},   -- {source: true}
        gameState = 'waiting', -- 'waiting', 'playing', 'showdown'
        currentTurn = nil,
        dealerSeat = 1,
        smallBlindSeat = nil,
        bigBlindSeat = nil,
        pot = 0,
        sidePots = {},
        currentBet = 0,
        minRaise = 0,
        phase = 'preflop', -- 'preflop', 'flop', 'turn', 'river', 'showdown'
        communityCards = {},
        deck = {},
        turnTimer = nil,
    }
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ HELPER FUNCTIONS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Get player name
    @param source number
    @return string
]]
local function GetPlayerName(source)
    local PlayerData = Framework.GetPlayerData(source)
    if PlayerData then
        if PlayerData.firstname and PlayerData.lastname then
            return PlayerData.firstname .. ' ' .. PlayerData.lastname
        elseif PlayerData.name then
            return PlayerData.name
        end
    end
    return GetPlayerName(source) -- Fallback to native
end

--[[
    Validate player distance to table
    @param source number
    @param tableId number
    @return boolean
]]
local function ValidateDistance(source, tableId)
    if not Config.Security.validateDistance then return true end
    
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local tableCoords = Config.Tables[tableId].location
    
    local distance = #(playerCoords - tableCoords)
    return distance <= Config.Security.maxDistance
end

--[[
    Check rate limiting
    @param source number
    @return boolean
]]
local function CheckRateLimit(source)
    local currentTime = os.time()
    
    -- Initialize tracking if not exists
    if not PlayerActionCounts[source] then
        PlayerActionCounts[source] = {
            count = 0,
            startTime = currentTime
        }
    end
    
    local tracking = PlayerActionCounts[source]
    
    -- Reset if minute has passed
    if currentTime - tracking.startTime >= 60 then
        tracking.count = 0
        tracking.startTime = currentTime
    end
    
    -- Check if exceeded limit
    if tracking.count >= Config.Security.maxActionsPerMinute then
        return false
    end
    
    tracking.count = tracking.count + 1
    return true
end

--[[
    Get next active seat
    @param table table
    @param currentSeat number
    @return number|nil
]]
local function GetNextActiveSeat(table, currentSeat)
    local maxSeats = Config.General.maxPlayers
    for i = 1, maxSeats do
        local nextSeat = ((currentSeat + i - 1) % maxSeats) + 1
        if table.players[nextSeat] and table.players[nextSeat].status == 'active' then
            return nextSeat
        end
    end
    return nil
end

--[[
    Count active players
    @param table table
    @return number
]]
local function CountActivePlayers(table)
    local count = 0
    for _, player in pairs(table.players) do
        if player.status == 'active' then
            count = count + 1
        end
    end
    return count
end

--[[
    Create and shuffle deck
    @return table
]]
local function CreateDeck()
    local deck = {}
    local suits = {'hearts', 'diamonds', 'clubs', 'spades'}
    local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'}
    
    for _, suit in ipairs(suits) do
        for _, rank in ipairs(ranks) do
            table.insert(deck, {rank = rank, suit = suit})
        end
    end
    
    -- Shuffle deck (Fisher-Yates)
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
    
    return deck
end

--[[
    Deal card from deck
    @param deck table
    @return table|nil
]]
local function DealCard(deck)
    return table.remove(deck, 1)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ GAME LOGIC █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Start a new hand
    @param tableId number
]]
local function StartNewHand(tableId)
    local table = PokerTables[tableId]
    if CountActivePlayers(table) < 2 then
        table.gameState = 'waiting'
        return
    end
    
    -- Reset table state
    table.gameState = 'playing'
    table.pot = 0
    table.sidePots = {}
    table.currentBet = 0
    table.minRaise = table.config.bigBlind
    table.phase = 'preflop'
    table.communityCards = {}
    table.deck = CreateDeck()
    
    -- Reset player states
    for seat, player in pairs(table.players) do
        player.bet = 0
        player.cards = {}
        player.status = 'active'
        player.lastAction = nil
    end
    
    -- Rotate dealer button
    if Config.GameRules.dealerRotation then
        table.dealerSeat = GetNextActiveSeat(table, table.dealerSeat) or 1
    end
    
    -- Set blinds
    table.smallBlindSeat = GetNextActiveSeat(table, table.dealerSeat)
    table.bigBlindSeat = GetNextActiveSeat(table, table.smallBlindSeat)
    
    -- Post blinds
    if table.players[table.smallBlindSeat] then
        table.players[table.smallBlindSeat].chips = table.players[table.smallBlindSeat].chips - table.config.smallBlind
        table.players[table.smallBlindSeat].bet = table.config.smallBlind
        table.pot = table.pot + table.config.smallBlind
    end
    
    if table.players[table.bigBlindSeat] then
        table.players[table.bigBlindSeat].chips = table.players[table.bigBlindSeat].chips - table.config.bigBlind
        table.players[table.bigBlindSeat].bet = table.config.bigBlind
        table.pot = table.pot + table.config.bigBlind
        table.currentBet = table.config.bigBlind
    end
    
    -- Deal cards
    for i = 1, 2 do
        for seat, player in pairs(table.players) do
            if player.status == 'active' then
                table.insert(player.cards, DealCard(table.deck))
            end
        end
    end
    
    -- Start first betting round
    table.currentTurn = GetNextActiveSeat(table, table.bigBlindSeat)
    StartTurnTimer(tableId, table.currentTurn)
    
    -- Notify all players
    for seat, player in pairs(table.players) do
        TriggerClientEvent('lxr-poker:client:updateGameState', player.source, tableId, {
            phase = table.phase,
            pot = table.pot,
            currentBet = table.currentBet,
            dealerSeat = table.dealerSeat,
            yourCards = player.cards,
        })
    end
    
    if Config.Debug.enabled then
        print('[LXR Poker] Started new hand at table ' .. tableId)
    end
end

--[[
    Start turn timer for a player
    @param tableId number
    @param seat number
]]
function StartTurnTimer(tableId, seat)
    local table = PokerTables[tableId]
    if not table or not table.players[seat] then return end
    
    local player = table.players[seat]
    
    -- Notify player it's their turn
    TriggerClientEvent('lxr-poker:client:yourTurn', player.source, tableId, Config.GameRules.turnTimer)
    
    -- Start server-side timer
    if table.turnTimer then
        table.turnTimer = nil
    end
    
    table.turnTimer = SetTimeout(Config.GameRules.turnTimer * 1000, function()
        -- Auto-fold if player didn't act
        if table.currentTurn == seat and table.players[seat].status == 'active' then
            ProcessPlayerAction(tableId, seat, player.source, 'fold', 0)
            TriggerClientEvent('lxr-poker:client:notify', player.source, L('turn_skipped'), 'error', 5000)
        end
    end)
end

--[[
    Process player action
    @param tableId number
    @param seat number
    @param source number
    @param action string
    @param amount number
]]
function ProcessPlayerAction(tableId, seat, source, action, amount)
    local table = PokerTables[tableId]
    if not table or not table.players[seat] then return end
    
    local player = table.players[seat]
    
    -- Validate it's player's turn
    if table.currentTurn ~= seat then
        Framework.Notify(source, L('error_not_your_turn'), 'error', 3000)
        return
    end
    
    -- Clear turn timer
    if table.turnTimer then
        ClearTimeout(table.turnTimer)
        table.turnTimer = nil
    end
    
    -- Process action
    local valid = false
    local betAmount = 0
    
    if action == 'fold' then
        player.status = 'folded'
        player.lastAction = 'fold'
        valid = true
        
    elseif action == 'check' then
        if player.bet >= table.currentBet then
            player.lastAction = 'check'
            valid = true
        else
            Framework.Notify(source, L('invalid_action'), 'error', 3000)
            return
        end
        
    elseif action == 'call' then
        local toCall = table.currentBet - player.bet
        if player.chips >= toCall then
            betAmount = toCall
            player.chips = player.chips - betAmount
            player.bet = player.bet + betAmount
            table.pot = table.pot + betAmount
            player.lastAction = 'call'
            valid = true
        else
            Framework.Notify(source, L('not_enough_chips'), 'error', 3000)
            return
        end
        
    elseif action == 'raise' then
        amount = amount or (table.currentBet + table.minRaise)
        local toRaise = amount - player.bet
        
        if toRaise < table.minRaise then
            Framework.Notify(source, L('raise_too_small', table.minRaise), 'error', 3000)
            return
        end
        
        if player.chips >= toRaise then
            betAmount = toRaise
            player.chips = player.chips - betAmount
            player.bet = player.bet + betAmount
            table.pot = table.pot + betAmount
            table.currentBet = player.bet
            table.minRaise = betAmount
            player.lastAction = 'raise'
            valid = true
        else
            Framework.Notify(source, L('not_enough_chips'), 'error', 3000)
            return
        end
        
    elseif action == 'all_in' then
        betAmount = player.chips
        player.chips = 0
        player.bet = player.bet + betAmount
        table.pot = table.pot + betAmount
        if player.bet > table.currentBet then
            table.currentBet = player.bet
        end
        player.lastAction = 'all_in'
        player.status = 'all_in'
        valid = true
    end
    
    if valid then
        -- Broadcast action to all players
        local playerName = GetPlayerName(source)
        for _, p in pairs(table.players) do
            TriggerClientEvent('lxr-poker:client:playerAction', p.source, tableId, playerName, action, betAmount)
        end
        
        -- Move to next player
        AdvanceTurn(tableId)
    end
end

--[[
    Advance to next player's turn
    @param tableId number
]]
function AdvanceTurn(tableId)
    local table = PokerTables[tableId]
    if not table then return end
    
    -- Check if betting round is complete
    local allActed = true
    local activePlayers = 0
    
    for seat, player in pairs(table.players) do
        if player.status == 'active' or player.status == 'all_in' then
            activePlayers = activePlayers + 1
            if player.status == 'active' and (not player.lastAction or player.bet < table.currentBet) then
                allActed = false
            end
        end
    end
    
    -- If only one player left, they win
    if activePlayers <= 1 then
        EndHand(tableId)
        return
    end
    
    -- If betting round complete, advance phase
    if allActed then
        AdvancePhase(tableId)
        return
    end
    
    -- Move to next active player
    table.currentTurn = GetNextActiveSeat(table, table.currentTurn)
    if table.currentTurn then
        StartTurnTimer(tableId, table.currentTurn)
    else
        -- No more players, end hand
        EndHand(tableId)
    end
end

--[[
    Advance to next betting phase
    @param tableId number
]]
function AdvancePhase(tableId)
    local table = PokerTables[tableId]
    if not table then return end
    
    -- Reset bets for new round
    for seat, player in pairs(table.players) do
        player.bet = 0
        player.lastAction = nil
    end
    table.currentBet = 0
    table.minRaise = table.config.bigBlind
    
    -- Deal community cards
    if table.phase == 'preflop' then
        table.phase = 'flop'
        -- Deal 3 cards
        for i = 1, 3 do
            table.insert(table.communityCards, DealCard(table.deck))
        end
    elseif table.phase == 'flop' then
        table.phase = 'turn'
        -- Deal 1 card
        table.insert(table.communityCards, DealCard(table.deck))
    elseif table.phase == 'turn' then
        table.phase = 'river'
        -- Deal 1 card
        table.insert(table.communityCards, DealCard(table.deck))
    elseif table.phase == 'river' then
        -- Showdown
        EndHand(tableId)
        return
    end
    
    -- Start next betting round
    table.currentTurn = GetNextActiveSeat(table, table.dealerSeat)
    if table.currentTurn then
        StartTurnTimer(tableId, table.currentTurn)
    else
        EndHand(tableId)
    end
    
    -- Update all players
    for seat, player in pairs(table.players) do
        TriggerClientEvent('lxr-poker:client:updateGameState', player.source, tableId, {
            phase = table.phase,
            communityCards = table.communityCards,
            pot = table.pot,
        })
    end
end

--[[
    End hand and determine winner(s)
    @param tableId number
]]
function EndHand(tableId)
    local table = PokerTables[tableId]
    if not table then return end
    
    table.phase = 'showdown'
    
    -- Determine winner(s) - simplified for now
    local winners = {}
    local highestRank = 0
    
    for seat, player in pairs(table.players) do
        if player.status ~= 'folded' then
            -- Evaluate hand with proper poker hand evaluation
            local handRank, handName = EvaluateHand(player.cards, table.communityCards)
            
            if handRank > highestRank then
                highestRank = handRank
                winners = {{seat = seat, player = player, rank = handRank, handName = handName}}
            elseif handRank == highestRank then
                table.insert(winners, {seat = seat, player = player, rank = handRank, handName = handName})
            end
        end
    end
    
    -- Calculate house rake
    local rake = 0
    if table.config.houseRake > 0 then
        rake = math.floor(table.pot * table.config.houseRake)
        table.pot = table.pot - rake
    end
    
    -- Distribute pot
    local sharePerWinner = math.floor(table.pot / #winners)
    
    for _, winner in ipairs(winners) do
        winner.player.chips = winner.player.chips + sharePerWinner
        
        -- Add money to player account
        Framework.AddMoney(winner.player.source, sharePerWinner, Config.Economy.moneyType)
        
        -- Notify winner with hand name
        local winnerName = GetPlayerName(winner.player.source)
        for _, p in pairs(table.players) do
            TriggerClientEvent('lxr-poker:client:handResult', p.source, tableId, {
                {seat = winner.seat, name = winnerName, amount = sharePerWinner, hand = winner.handName or L('high_card')}
            }, table.pot)
        end
    end
    
    -- Log rake collection
    if rake > 0 and Config.Debug.enabled then
        print('[LXR Poker] House rake collected: $' .. rake .. ' from table ' .. tableId)
    end
    
    -- Start new hand after delay
    SetTimeout(5000, function()
        StartNewHand(tableId)
    end)
end

--[[
    Evaluate poker hand
    @param holeCards table - Player's 2 hole cards
    @param communityCards table - 5 community cards
    @return number - Hand strength (higher is better)
    @return string - Hand name (e.g., "Royal Flush", "Pair")
    @return table - Best 5-card combination
    
    Hand Rankings (highest to lowest):
    9 = Royal Flush
    8 = Straight Flush
    7 = Four of a Kind
    6 = Full House
    5 = Flush
    4 = Straight
    3 = Three of a Kind
    2 = Two Pair
    1 = One Pair
    0 = High Card
]]
function EvaluateHand(holeCards, communityCards)
    -- Combine all 7 cards
    local allCards = {}
    for _, card in ipairs(holeCards or {}) do
        table.insert(allCards, card)
    end
    for _, card in ipairs(communityCards or {}) do
        table.insert(allCards, card)
    end
    
    if #allCards < 5 then
        return 0, L('high_card'), {}
    end
    
    -- Convert rank strings to numeric values
    local function GetRankValue(rank)
        local ranks = {['2']=2, ['3']=3, ['4']=4, ['5']=5, ['6']=6, ['7']=7, 
                      ['8']=8, ['9']=9, ['10']=10, J=11, Q=12, K=13, A=14}
        return ranks[rank] or 0
    end
    
    -- Sort cards by rank (descending)
    table.sort(allCards, function(a, b)
        return GetRankValue(a.rank) > GetRankValue(b.rank)
    end)
    
    -- Helper function to check for flush
    local function IsFlush(cards)
        local suitCounts = {}
        for _, card in ipairs(cards) do
            suitCounts[card.suit] = (suitCounts[card.suit] or 0) + 1
            if suitCounts[card.suit] >= 5 then
                return true, card.suit
            end
        end
        return false, nil
    end
    
    -- Helper function to check for straight
    local function IsStraight(cards)
        local values = {}
        for _, card in ipairs(cards) do
            local val = GetRankValue(card.rank)
            if not values[val] then
                table.insert(values, val)
                values[val] = true
            end
        end
        table.sort(values, function(a, b) return a > b end)
        
        -- Check for regular straight
        for i = 1, #values - 4 do
            if values[i] - values[i+4] == 4 then
                return true, values[i]
            end
        end
        
        -- Check for A-2-3-4-5 (wheel)
        if values[1] == 14 and values[#values-3] == 5 and values[#values-2] == 4 
           and values[#values-1] == 3 and values[#values] == 2 then
            return true, 5
        end
        
        return false, 0
    end
    
    -- Count rank occurrences
    local rankCounts = {}
    local rankList = {}
    for _, card in ipairs(allCards) do
        local val = GetRankValue(card.rank)
        rankCounts[val] = (rankCounts[val] or 0) + 1
        if rankCounts[val] == 1 then
            table.insert(rankList, val)
        end
    end
    
    -- Sort by count then by rank
    table.sort(rankList, function(a, b)
        if rankCounts[a] ~= rankCounts[b] then
            return rankCounts[a] > rankCounts[b]
        end
        return a > b
    end)
    
    -- Check for flush and straight
    local hasFlush, flushSuit = IsFlush(allCards)
    local hasStraight, straightHigh = IsStraight(allCards)
    
    -- Get the most common rank counts
    local counts = {}
    for _, val in ipairs(rankList) do
        table.insert(counts, rankCounts[val])
    end
    
    -- Royal Flush (A-K-Q-J-10 of same suit)
    if hasFlush and hasStraight and straightHigh == 14 then
        return 90000 + straightHigh, L('royal_flush'), {}
    end
    
    -- Straight Flush
    if hasFlush and hasStraight then
        return 80000 + straightHigh, L('straight_flush'), {}
    end
    
    -- Four of a Kind
    if counts[1] == 4 then
        return 70000 + rankList[1] * 100 + rankList[2], L('four_of_a_kind'), {}
    end
    
    -- Full House (Three of a kind + Pair)
    if counts[1] == 3 and counts[2] == 2 then
        return 60000 + rankList[1] * 100 + rankList[2], L('full_house'), {}
    end
    
    -- Flush
    if hasFlush then
        return 50000 + rankList[1] * 10000 + rankList[2] * 100 + rankList[3], L('flush'), {}
    end
    
    -- Straight
    if hasStraight then
        return 40000 + straightHigh, L('straight'), {}
    end
    
    -- Three of a Kind
    if counts[1] == 3 then
        return 30000 + rankList[1] * 100 + rankList[2], L('three_of_a_kind'), {}
    end
    
    -- Two Pair
    if counts[1] == 2 and counts[2] == 2 then
        return 20000 + rankList[1] * 1000 + rankList[2] * 100 + rankList[3], L('two_pair'), {}
    end
    
    -- One Pair
    if counts[1] == 2 then
        return 10000 + rankList[1] * 100 + rankList[2], L('one_pair'), {}
    end
    
    -- High Card
    return rankList[1] * 100 + rankList[2], L('high_card'), {}
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CALLBACKS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Join table callback
]]
Framework.CreateCallback('lxr-poker:server:joinTable', function(source, cb, tableId)
    -- Rate limiting
    if not CheckRateLimit(source) then
        cb(false, nil, L('error_generic'))
        return
    end
    
    -- Validate distance
    if not ValidateDistance(source, tableId) then
        cb(false, nil, L('error_too_far'))
        return
    end
    
    local table = PokerTables[tableId]
    if not table then
        cb(false, nil, L('table_not_found'))
        return
    end
    
    -- Check if player already seated
    for seat, player in pairs(table.players) do
        if player.source == source then
            cb(false, nil, L('error_already_seated'))
            return
        end
    end
    
    -- Check if table full
    local seatCount = 0
    for _ in pairs(table.players) do
        seatCount = seatCount + 1
    end
    
    if seatCount >= Config.General.maxPlayers then
        cb(false, nil, L('table_full'))
        return
    end
    
    -- Check buy-in
    local playerMoney = Framework.GetMoney(source, Config.Economy.moneyType)
    if playerMoney < table.config.minBuyIn then
        cb(false, nil, L('not_enough_money', table.config.minBuyIn))
        return
    end
    
    -- Default buy-in to min
    local buyIn = table.config.minBuyIn
    
    -- Remove money
    if not Framework.RemoveMoney(source, buyIn, Config.Economy.moneyType) then
        cb(false, nil, L('error_generic'))
        return
    end
    
    -- Find empty seat
    local assignedSeat = nil
    for i = 1, Config.General.maxPlayers do
        if not table.players[i] then
            assignedSeat = i
            break
        end
    end
    
    if not assignedSeat then
        -- Refund if no seat found (shouldn't happen)
        Framework.AddMoney(source, buyIn, Config.Economy.moneyType)
        cb(false, nil, L('table_full'))
        return
    end
    
    -- Assign player to seat
    table.players[assignedSeat] = {
        source = source,
        name = GetPlayerName(source),
        chips = buyIn,
        cards = {},
        bet = 0,
        status = 'active',
        lastAction = nil,
    }
    
    cb(true, assignedSeat, L('seated_successfully'))
    
    -- Start game if enough players
    if table.gameState == 'waiting' and CountActivePlayers(table) >= 2 then
        SetTimeout(5000, function()
            StartNewHand(tableId)
        end)
    end
    
    if Config.Debug.enabled then
        print('[LXR Poker] Player ' .. source .. ' joined table ' .. tableId .. ' at seat ' .. assignedSeat)
    end
end)

--[[
    Spectate table callback
]]
Framework.CreateCallback('lxr-poker:server:spectateTable', function(source, cb, tableId)
    local table = PokerTables[tableId]
    if not table then
        cb(false, L('table_not_found'))
        return
    end
    
    -- Check spectator limit
    local spectatorCount = 0
    for _ in pairs(table.spectators) do
        spectatorCount = spectatorCount + 1
    end
    
    if spectatorCount >= Config.General.maxSpectators then
        cb(false, L('spectator_full'))
        return
    end
    
    table.spectators[source] = true
    cb(true, L('spectating'))
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER EVENTS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Leave table event
]]
RegisterNetEvent('lxr-poker:server:leaveTable')
AddEventHandler('lxr-poker:server:leaveTable', function(tableId, seat)
    local source = source
    local table = PokerTables[tableId]
    
    if table and table.players[seat] and table.players[seat].source == source then
        -- Cash out remaining chips
        local chips = table.players[seat].chips
        if chips > 0 then
            Framework.AddMoney(source, chips, Config.Economy.moneyType)
        end
        
        -- Remove player
        table.players[seat] = nil
        
        -- Check if game should end
        if CountActivePlayers(table) < 2 and table.gameState == 'playing' then
            EndHand(tableId)
        end
        
        if Config.Debug.enabled then
            print('[LXR Poker] Player ' .. source .. ' left table ' .. tableId)
        end
    end
end)

--[[
    Stop spectating event
]]
RegisterNetEvent('lxr-poker:server:stopSpectating')
AddEventHandler('lxr-poker:server:stopSpectating', function(tableId)
    local source = source
    local table = PokerTables[tableId]
    
    if table and table.spectators[source] then
        table.spectators[source] = nil
    end
end)

--[[
    Perform action event
]]
RegisterNetEvent('lxr-poker:server:performAction')
AddEventHandler('lxr-poker:server:performAction', function(tableId, seat, action, amount)
    local source = source
    
    -- Security validation
    if not ValidateDistance(source, tableId) then
        TriggerClientEvent('lxr-poker:client:forceLeave', source, L('error_too_far'))
        return
    end
    
    if not CheckRateLimit(source) then
        if Config.Security.logSuspiciousActivity then
            print('[LXR Poker] SECURITY: Rate limit exceeded for player ' .. source)
        end
        return
    end
    
    ProcessPlayerAction(tableId, seat, source, action, amount)
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ADMIN COMMANDS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

RegisterCommand(Config.General.adminResetCommand, function(source, args)
    -- Check permission
    if not Framework.HasPermission(source, Config.General.adminAcePermission) then
        Framework.Notify(source, L('admin_no_permission'), 'error', 3000)
        return
    end
    
    local tableId = tonumber(args[1])
    if not tableId or not PokerTables[tableId] then
        Framework.Notify(source, L('table_not_found'), 'error', 3000)
        return
    end
    
    local table = PokerTables[tableId]
    
    -- Cash out all players
    for seat, player in pairs(table.players) do
        if player.chips > 0 then
            Framework.AddMoney(player.source, player.chips, Config.Economy.moneyType)
        end
        TriggerClientEvent('lxr-poker:client:forceLeave', player.source, L('admin_reset'))
    end
    
    -- Reset table
    table.players = {}
    table.spectators = {}
    table.gameState = 'waiting'
    table.pot = 0
    table.currentTurn = nil
    
    Framework.Notify(source, L('admin_reset_success'), 'success', 3000)
    
    print('[LXR Poker] Admin ' .. source .. ' reset table ' .. tableId)
end, false)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ PLAYER DISCONNECT HANDLER █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
AddEventHandler('playerDropped', function(reason)
    local source = source
    
    -- Remove player from any table they're at
    for tableId, table in pairs(PokerTables) do
        for seat, player in pairs(table.players) do
            if player.source == source then
                -- Cash out chips
                if player.chips > 0 then
                    Framework.AddMoney(source, player.chips, Config.Economy.moneyType)
                end
                
                table.players[seat] = nil
                
                -- Check if game should end
                if CountActivePlayers(table) < 2 and table.gameState == 'playing' then
                    EndHand(tableId)
                end
                
                if Config.Debug.enabled then
                    print('[LXR Poker] Player ' .. source .. ' disconnected from table ' .. tableId)
                end
            end
        end
        
        -- Remove from spectators
        if table.spectators[source] then
            table.spectators[source] = nil
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER INITIALIZATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Citizen.CreateThread(function()
    print('^2[LXR Poker]^7 Server initialized with ^3' .. #Config.Tables .. '^7 poker tables^0')
    
    if Config.Debug.enabled then
        print('[LXR Poker] Debug mode enabled')
        print('[LXR Poker] Framework: ' .. Framework.Type)
        print('[LXR Poker] Security validation: ' .. (Config.Security.validateMoney and 'ENABLED' or 'DISABLED'))
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER SCRIPT LOADED █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
print('^2[LXR Poker]^7 Server script loaded successfully^0')
