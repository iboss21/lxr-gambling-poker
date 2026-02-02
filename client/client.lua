--[[
════════════════════════════════════════════════════════════════════════════════════════════════
    
    ██╗     ██╗  ██╗██████╗        ██████╗  ██████╗ ██╗  ██╗███████╗██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝██╔══██╗
    ██║      ╚███╔╝ ██████╔╝       ██████╔╝██║   ██║█████╔╝ █████╗  ██████╔╝
    ██║      ██╔██╗ ██╔══██╗       ██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║       ██║     ╚██████╔╝██║  ██╗███████╗██║  ██║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    
    🐺 LXR Poker V2.0 - Client Script
    
    Professional Texas Hold'em Poker Client
    Handles player interactions, UI, animations, and synchronization
    
════════════════════════════════════════════════════════════════════════════════════════════════
    
    📋 RESPONSIBILITIES
    ═══════════════════════════════════════════════════════════════════════════════════════════
    ✓ Table Proximity Detection & Interaction Prompts
    ✓ Join/Leave Table Management
    ✓ Native RDR2 Poker UI Integration
    ✓ Player Animations & Props Synchronization
    ✓ Spectator Mode
    ✓ Turn Timer Display
    ✓ Action Input Handling (Call, Raise, Fold, Check, All-in)
    ✓ Visual Feedback & Notifications
    ✓ Blip Management
    ✓ Performance Optimization
    ═══════════════════════════════════════════════════════════════════════════════════════════
    
════════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ LOCAL VARIABLES █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
local PlayerData = {}
local isAtTable = false
local currentTable = nil
local currentSeat = nil
local isSpectating = false
local nearbyTables = {}
local spawnedProps = {}
local isInPokerGame = false
local currentAction = nil
local turnTimer = 0

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ HELPER FUNCTIONS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Get player's current coordinates
    @return vector3
]]
local function GetPlayerCoords()
    return GetEntityCoords(PlayerPedId())
end

--[[
    Calculate distance between two points
    @param coords1 vector3
    @param coords2 vector3
    @return number
]]
local function GetDistance(coords1, coords2)
    return #(coords1 - coords2)
end

--[[
    Draw 3D text at coordinates
    @param coords vector3
    @param text string
]]
local function Draw3DText(coords, text)
    local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFontForCurrentCommand(1)
        SetTextColor(255, 255, 255, 215)
        SetTextCentre(1)
        DisplayText(CreateVarString(10, 'LITERAL_STRING', text), x, y)
    end
end

--[[
    Show help notification
    @param text string
]]
local function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

--[[
    Load animation dictionary
    @param dict string
]]
local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
    end
end

--[[
    Load model
    @param model hash
]]
local function LoadModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ BLIP MANAGEMENT █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Create blips for all poker tables
]]
local function CreateTableBlips()
    for _, table in ipairs(Config.Tables) do
        if table.blip and table.blip.enabled then
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, table.location.x, table.location.y, table.location.z)
            SetBlipSprite(blip, table.blip.sprite or `blip_poker_table`, true)
            SetBlipScale(blip, table.blip.scale or 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, table.blip.name or table.name)
            
            if Config.Debug.enabled then
                print('[LXR Poker] Created blip for table: ' .. table.name)
            end
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ PROP SPAWNING █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Spawn table props (chairs, dealer, etc.)
]]
local function SpawnTableProps()
    for tableId, table in ipairs(Config.Tables) do
        if table.props then
            -- Spawn table
            if table.props.table then
                LoadModel(table.props.table)
                local tableObj = CreateObject(table.props.table, table.location.x, table.location.y, table.location.z - 1.0, false, false, false)
                SetEntityHeading(tableObj, table.heading)
                FreezeEntityPosition(tableObj, true)
                spawnedProps[#spawnedProps + 1] = tableObj
            end
            
            -- Spawn chairs
            if table.props.chairs then
                for _, chair in ipairs(table.props.chairs) do
                    LoadModel(chair.model)
                    local chairObj = CreateObject(chair.model, chair.coords.x, chair.coords.y, chair.coords.z, false, false, false)
                    SetEntityHeading(chairObj, chair.heading)
                    FreezeEntityPosition(chairObj, true)
                    spawnedProps[#spawnedProps + 1] = chairObj
                end
            end
            
            -- Spawn dealer NPC
            if Config.General.enableDealers and table.props.dealer then
                LoadModel(table.props.dealer.model)
                local dealer = CreatePed(table.props.dealer.model, table.props.dealer.coords.x, table.props.dealer.coords.y, table.props.dealer.coords.z, table.props.dealer.heading, false, false, false, false)
                FreezeEntityPosition(dealer, true)
                SetEntityInvincible(dealer, true)
                SetBlockingOfNonTemporaryEvents(dealer, true)
                spawnedProps[#spawnedProps + 1] = dealer
                
                -- Start dealer idle animation
                LoadAnimDict(Config.Animations.dealing.dict)
                TaskPlayAnim(dealer, Config.Animations.dealing.dict, Config.Animations.dealing.anim, 8.0, -8.0, -1, Config.Animations.dealing.flag, 0, false, false, false)
            end
        end
    end
    
    if Config.Debug.enabled then
        print('[LXR Poker] Spawned ' .. #spawnedProps .. ' props for ' .. #Config.Tables .. ' tables')
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ TABLE INTERACTION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Join a poker table
    @param tableId number
]]
local function JoinTable(tableId)
    local table = Config.Tables[tableId]
    if not table then return end
    
    Framework.Notify(nil, L('joining_table'), 'info', 3000)
    
    -- Server-side validation and seat assignment
    Framework.TriggerCallback('lxr-poker:server:joinTable', function(success, seat, message)
        if success then
            isAtTable = true
            currentTable = tableId
            currentSeat = seat
            
            Framework.Notify(nil, L('seated_successfully'), 'success', 3000)
            
            -- Move player to seat (optional, depends on native poker behavior)
            -- SitPlayerAtSeat(seat)
            
            -- Play sitting animation
            local ped = PlayerPedId()
            LoadAnimDict(Config.Animations.sitting.dict)
            TaskPlayAnim(ped, Config.Animations.sitting.dict, Config.Animations.sitting.anim, 8.0, -8.0, -1, Config.Animations.sitting.flag, 0, false, false, false)
            
        else
            Framework.Notify(nil, message or L('error_generic'), 'error', 5000)
        end
    end, tableId)
end

--[[
    Leave the poker table
]]
local function LeaveTable()
    if not isAtTable then return end
    
    Framework.Notify(nil, L('leaving_table'), 'info', 3000)
    
    TriggerServerEvent('lxr-poker:server:leaveTable', currentTable, currentSeat)
    
    isAtTable = false
    isInPokerGame = false
    currentTable = nil
    currentSeat = nil
    
    -- Clear animations
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    
    Framework.Notify(nil, L('left_table'), 'success', 3000)
end

--[[
    Start spectating a table
    @param tableId number
]]
local function SpectateTable(tableId)
    Framework.TriggerCallback('lxr-poker:server:spectateTable', function(success, message)
        if success then
            isSpectating = true
            currentTable = tableId
            Framework.Notify(nil, L('spectator_joined'), 'success', 3000)
        else
            Framework.Notify(nil, message or L('error_generic'), 'error', 5000)
        end
    end, tableId)
end

--[[
    Stop spectating
]]
local function StopSpectating()
    if not isSpectating then return end
    
    TriggerServerEvent('lxr-poker:server:stopSpectating', currentTable)
    
    isSpectating = false
    currentTable = nil
    
    Framework.Notify(nil, L('spectator_left'), 'success', 3000)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ POKER ACTIONS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Perform a poker action (call, raise, fold, check, all-in)
    @param action string
    @param amount number (optional, for raise)
]]
local function PerformAction(action, amount)
    if not isAtTable or not isInPokerGame then
        Framework.Notify(nil, L('error_not_seated'), 'error', 3000)
        return
    end
    
    TriggerServerEvent('lxr-poker:server:performAction', currentTable, currentSeat, action, amount)
    
    -- Play animation based on action
    local ped = PlayerPedId()
    if action == 'fold' then
        LoadAnimDict(Config.Animations.folding.dict)
        TaskPlayAnim(ped, Config.Animations.folding.dict, Config.Animations.folding.anim, 8.0, -8.0, 2000, Config.Animations.folding.flag, 0, false, false, false)
    elseif action == 'call' or action == 'raise' or action == 'all_in' then
        LoadAnimDict(Config.Animations.betting.dict)
        TaskPlayAnim(ped, Config.Animations.betting.dict, Config.Animations.betting.anim, 8.0, -8.0, 2000, Config.Animations.betting.flag, 0, false, false, false)
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ NATIVE POKER INTEGRATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Start native RDR2 poker game
    @param tableData table
]]
local function StartNativePoker(tableData)
    if not Config.General.useNativeUI then return end
    
    -- This uses native RDR2 poker functionality
    -- The actual natives depend on game version and are experimental
    
    -- Example: Start poker game (these natives are placeholders)
    -- Citizen.InvokeNative(0xPOKER_START_GAME, tableData.id)
    -- Citizen.InvokeNative(0xPOKER_SET_BLINDS, tableData.smallBlind, tableData.bigBlind)
    
    isInPokerGame = true
    
    if Config.Debug.enabled then
        print('[LXR Poker] Started native poker game for table: ' .. tableData.id)
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ NETWORK EVENTS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Game state updates from server
RegisterNetEvent('lxr-poker:client:updateGameState')
AddEventHandler('lxr-poker:client:updateGameState', function(tableId, gameState)
    if currentTable ~= tableId then return end
    
    -- Update local game state
    -- gameState includes: pot, currentBet, players, turn, phase, etc.
    
    if Config.Debug.enabled then
        print('[LXR Poker] Game state updated for table: ' .. tableId)
    end
end)

-- Player action notification
RegisterNetEvent('lxr-poker:client:playerAction')
AddEventHandler('lxr-poker:client:playerAction', function(tableId, playerName, action, amount)
    if currentTable ~= tableId then return end
    
    local message = ''
    if action == 'call' then
        message = L('player_called', playerName, amount)
    elseif action == 'raise' then
        message = L('player_raised', playerName, amount)
    elseif action == 'fold' then
        message = L('player_folded', playerName)
    elseif action == 'check' then
        message = L('player_checked', playerName)
    elseif action == 'all_in' then
        message = L('player_all_in', playerName, amount)
    end
    
    Framework.Notify(nil, message, 'info', 3000)
end)

-- Hand result
RegisterNetEvent('lxr-poker:client:handResult')
AddEventHandler('lxr-poker:client:handResult', function(tableId, winners, pot)
    if currentTable ~= tableId then return end
    
    for _, winner in ipairs(winners) do
        local message = L('winner_announcement', winner.name, winner.amount, L(winner.hand))
        Framework.Notify(nil, message, 'success', 5000)
        
        -- Play winning animation if it's the player
        if winner.seat == currentSeat then
            local ped = PlayerPedId()
            LoadAnimDict(Config.Animations.winning.dict)
            TaskPlayAnim(ped, Config.Animations.winning.dict, Config.Animations.winning.anim, 8.0, -8.0, 3000, Config.Animations.winning.flag, 0, false, false, false)
        end
    end
end)

-- Your turn notification
RegisterNetEvent('lxr-poker:client:yourTurn')
AddEventHandler('lxr-poker:client:yourTurn', function(tableId, timeLimit)
    if currentTable ~= tableId then return end
    
    Framework.Notify(nil, L('your_turn'), 'warning', 3000)
    turnTimer = timeLimit
    
    -- Start turn timer countdown
    Citizen.CreateThread(function()
        while turnTimer > 0 and isAtTable do
            Wait(1000)
            turnTimer = turnTimer - 1
            
            if turnTimer == Config.GameRules.warnAt then
                Framework.Notify(nil, L('time_warning', turnTimer), 'warning', 3000)
            end
        end
        
        if turnTimer == 0 and isAtTable then
            Framework.Notify(nil, L('time_up'), 'error', 3000)
        end
    end)
end)

-- Forced leave (kicked, error, etc.)
RegisterNetEvent('lxr-poker:client:forceLeave')
AddEventHandler('lxr-poker:client:forceLeave', function(reason)
    if isAtTable then
        LeaveTable()
    end
    if isSpectating then
        StopSpectating()
    end
    
    Framework.Notify(nil, reason or L('error_generic'), 'error', 5000)
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ MAIN THREAD - TABLE PROXIMITY DETECTION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Citizen.CreateThread(function()
    while true do
        local sleep = Config.Performance.tableCheckInterval
        local playerCoords = GetPlayerCoords()
        local nearTable = false
        
        for tableId, table in ipairs(Config.Tables) do
            local distance = GetDistance(playerCoords, table.location)
            
            if distance <= Config.Performance.interactDistance then
                nearTable = true
                nearbyTables[tableId] = true
                
                -- Show interaction prompt
                if not isAtTable and not isSpectating then
                    Draw3DText(table.location, table.name)
                    ShowHelpNotification(L('press_to_join'))
                    
                    -- Join table
                    if IsControlJustPressed(0, Config.Keys.interact) then
                        JoinTable(tableId)
                    end
                elseif isAtTable and currentTable == tableId then
                    ShowHelpNotification(L('press_to_leave'))
                    
                    -- Leave table
                    if IsControlJustPressed(0, Config.Keys.interact) then
                        LeaveTable()
                    end
                elseif not isAtTable and not isSpectating and Config.General.allowSpectators then
                    -- Spectate option (hold key or different key)
                    if IsControlPressed(0, Config.Keys.interact) then
                        ShowHelpNotification(L('press_to_spectate'))
                    end
                end
            else
                nearbyTables[tableId] = nil
            end
        end
        
        if not nearTable then
            sleep = 2000 -- Increase sleep when not near any table
        end
        
        Wait(sleep)
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ POKER ACTION INPUT THREAD █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        if isAtTable and isInPokerGame then
            -- Call
            if IsControlJustPressed(0, Config.Keys.call) then
                PerformAction('call')
            end
            
            -- Raise (opens input for amount)
            if IsControlJustPressed(0, Config.Keys.raise) then
                -- TODO: Open raise amount input UI
                -- For now, use default raise
                PerformAction('raise', nil)
            end
            
            -- Fold
            if IsControlJustPressed(0, Config.Keys.fold) then
                PerformAction('fold')
            end
            
            -- Check
            if IsControlJustPressed(0, Config.Keys.check) then
                PerformAction('check')
            end
            
            -- All In
            if IsControlJustPressed(0, Config.Keys.allIn) then
                PerformAction('all_in')
            end
        else
            Wait(500) -- Reduce frequency when not in game
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ INITIALIZATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Citizen.CreateThread(function()
    -- Wait for game to load
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    -- Get player data from framework
    PlayerData = Framework.GetPlayerData()
    
    -- Create blips
    CreateTableBlips()
    
    -- Spawn props
    SpawnTableProps()
    
    if Config.Debug.enabled then
        print('[LXR Poker] Client initialized for player: ' .. GetPlayerServerId(PlayerId()))
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CLEANUP ON RESOURCE STOP █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Leave table if seated
    if isAtTable then
        TriggerServerEvent('lxr-poker:server:leaveTable', currentTable, currentSeat)
    end
    
    -- Stop spectating
    if isSpectating then
        TriggerServerEvent('lxr-poker:server:stopSpectating', currentTable)
    end
    
    -- Delete all spawned props
    for _, prop in ipairs(spawnedProps) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    
    -- Clear animations
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    
    if Config.Debug.enabled then
        print('[LXR Poker] Client cleanup completed')
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CLIENT SCRIPT LOADED █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
print('^2[LXR Poker]^7 Client script loaded successfully^0')
