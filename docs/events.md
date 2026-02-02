```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Events & API Reference
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Events & API Reference

Complete reference for all events, callbacks, and API functions.

## 📋 Table of Contents

- [Client Events](#client-events)
- [Server Events](#server-events)
- [Server Callbacks](#server-callbacks)
- [Exports](#exports)
- [Framework API](#framework-api)

---

## 🖥️ Client Events

Events triggered from server to client.

### `lxr-poker:client:updateGameState`

Update game state for a player at a table.

**Parameters:**
- `tableId` (number) - Table identifier
- `gameState` (table) - Game state data

**Example:**
```lua
TriggerClientEvent('lxr-poker:client:updateGameState', source, tableId, {
    phase = 'flop',
    pot = 250,
    currentBet = 50,
    communityCards = {...},
})
```

### `lxr-poker:client:playerAction`

Notify clients of a player's action.

**Parameters:**
- `tableId` (number) - Table identifier
- `playerName` (string) - Player name
- `action` (string) - Action type (`'call'`, `'raise'`, `'fold'`, `'check'`, `'all_in'`)
- `amount` (number) - Bet amount (if applicable)

**Example:**
```lua
TriggerClientEvent('lxr-poker:client:playerAction', -1, tableId, 'John Doe', 'raise', 100)
```

### `lxr-poker:client:handResult`

Show hand result to players.

**Parameters:**
- `tableId` (number) - Table identifier
- `winners` (table) - Array of winner data
- `pot` (number) - Total pot amount

**Example:**
```lua
TriggerClientEvent('lxr-poker:client:handResult', source, tableId, {
    {seat = 2, name = 'John Doe', amount = 500, hand = 'royal_flush'}
}, 1000)
```

### `lxr-poker:client:yourTurn`

Notify player it's their turn.

**Parameters:**
- `tableId` (number) - Table identifier
- `timeLimit` (number) - Turn timer in seconds

**Example:**
```lua
TriggerClientEvent('lxr-poker:client:yourTurn', source, tableId, 60)
```

### `lxr-poker:client:forceLeave`

Force player to leave table.

**Parameters:**
- `reason` (string) - Reason for leaving

**Example:**
```lua
TriggerClientEvent('lxr-poker:client:forceLeave', source, 'Table reset by admin')
```

### `lxr-poker:client:notify`

Send notification to player.

**Parameters:**
- `message` (string) - Notification text
- `type` (string) - `'success'`, `'error'`, `'info'`, `'warning'`
- `duration` (number) - Duration in milliseconds

**Example:**
```lua
TriggerClientEvent('lxr-poker:client:notify', source, 'You won!', 'success', 5000)
```

---

## 🖥️ Server Events

Events triggered from client to server.

### `lxr-poker:server:leaveTable`

Player requests to leave table.

**Parameters:**
- `tableId` (number) - Table identifier
- `seat` (number) - Player's seat number

**Usage:**
```lua
TriggerServerEvent('lxr-poker:server:leaveTable', tableId, seat)
```

**Server Handler:**
```lua
RegisterNetEvent('lxr-poker:server:leaveTable')
AddEventHandler('lxr-poker:server:leaveTable', function(tableId, seat)
    local source = source
    -- Handle leave logic
end)
```

### `lxr-poker:server:stopSpectating`

Player stops spectating.

**Parameters:**
- `tableId` (number) - Table identifier

**Usage:**
```lua
TriggerServerEvent('lxr-poker:server:stopSpectating', tableId)
```

### `lxr-poker:server:performAction`

Player performs poker action.

**Parameters:**
- `tableId` (number) - Table identifier
- `seat` (number) - Player's seat number
- `action` (string) - Action type
- `amount` (number) - Bet amount (optional)

**Usage:**
```lua
TriggerServerEvent('lxr-poker:server:performAction', tableId, seat, 'raise', 100)
```

**Actions:**
- `'call'` - Match current bet
- `'raise'` - Raise bet (requires amount)
- `'fold'` - Fold hand
- `'check'` - Check (if no bet to call)
- `'all_in'` - Bet all chips

---

## 📡 Server Callbacks

Callbacks for client-server communication.

### `lxr-poker:server:joinTable`

Request to join a poker table.

**Parameters:**
- `tableId` (number) - Table identifier

**Returns:**
- `success` (boolean) - Join succeeded
- `seat` (number) - Assigned seat number
- `message` (string) - Status message

**Usage:**
```lua
Framework.TriggerCallback('lxr-poker:server:joinTable', function(success, seat, message)
    if success then
        print("Joined table at seat: " .. seat)
    else
        print("Failed to join: " .. message)
    end
end, tableId)
```

**Server Implementation:**
```lua
Framework.CreateCallback('lxr-poker:server:joinTable', function(source, cb, tableId)
    -- Validate and assign seat
    cb(success, seat, message)
end)
```

### `lxr-poker:server:spectateTable`

Request to spectate a table.

**Parameters:**
- `tableId` (number) - Table identifier

**Returns:**
- `success` (boolean) - Spectate succeeded
- `message` (string) - Status message

**Usage:**
```lua
Framework.TriggerCallback('lxr-poker:server:spectateTable', function(success, message)
    if success then
        print("Now spectating")
    end
end, tableId)
```

---

## 📤 Exports

Resource exports for external scripts.

### Server Exports

#### `GetTableData`

Get data for a specific table.

**Parameters:**
- `tableId` (number) - Table identifier

**Returns:** Table data

**Usage:**
```lua
local tableData = exports['lxr-gambling-poker']:GetTableData(1)
print("Pot: $" .. tableData.pot)
```

#### `GetPlayerTable`

Get which table a player is at.

**Parameters:**
- `source` (number) - Player source ID

**Returns:** `tableId` or `nil`

**Usage:**
```lua
local tableId = exports['lxr-gambling-poker']:GetPlayerTable(source)
if tableId then
    print("Player is at table: " .. tableId)
end
```

#### `ForceLeaveTable`

Force a player to leave their table.

**Parameters:**
- `source` (number) - Player source ID
- `reason` (string) - Reason

**Usage:**
```lua
exports['lxr-gambling-poker']:ForceLeaveTable(source, 'Banned from gambling')
```

#### `ResetTable`

Reset a table (admin function).

**Parameters:**
- `tableId` (number) - Table identifier

**Usage:**
```lua
exports['lxr-gambling-poker']:ResetTable(1)
```

### Client Exports

#### `IsAtTable`

Check if player is currently at a table.

**Returns:** boolean

**Usage:**
```lua
local atTable = exports['lxr-gambling-poker']:IsAtTable()
if atTable then
    print("Player is playing poker")
end
```

#### `GetCurrentTable`

Get current table ID.

**Returns:** `tableId` or `nil`

**Usage:**
```lua
local tableId = exports['lxr-gambling-poker']:GetCurrentTable()
```

#### `IsSpectating`

Check if player is spectating.

**Returns:** boolean

**Usage:**
```lua
local spectating = exports['lxr-gambling-poker']:IsSpectating()
```

---

## 🔧 Framework API

Framework adapter unified API.

### Player Functions

```lua
-- Get player data
local PlayerData = Framework.GetPlayerData(source)

-- Get money
local cash = Framework.GetMoney(source, 'cash')
local bank = Framework.GetMoney(source, 'bank')

-- Add money
Framework.AddMoney(source, 100, 'cash')

-- Remove money
Framework.RemoveMoney(source, 50, 'cash')
```

### Notification Functions

```lua
-- Server-side
Framework.Notify(source, 'Message', 'success', 5000)

-- Client-side
Framework.Notify(nil, 'Message', 'info', 3000)
```

### Callback Functions

```lua
-- Server: Create callback
Framework.CreateCallback('myCallback', function(source, cb, arg1)
    cb(result)
end)

-- Client: Trigger callback
Framework.TriggerCallback('myCallback', function(result)
    print(result)
end, arg1)
```

### Permission Functions

```lua
-- Check permission
if Framework.HasPermission(source, 'poker.admin') then
    -- Player is admin
end
```

---

## 🎯 Usage Examples

### Example 1: Join Table Flow

```lua
-- Client
Framework.TriggerCallback('lxr-poker:server:joinTable', function(success, seat, message)
    if success then
        Framework.Notify(nil, 'Joined table!', 'success', 3000)
        isAtTable = true
        currentSeat = seat
    else
        Framework.Notify(nil, message, 'error', 5000)
    end
end, tableId)

-- Server
Framework.CreateCallback('lxr-poker:server:joinTable', function(source, cb, tableId)
    -- Validate player has money
    local money = Framework.GetMoney(source, 'cash')
    if money < minBuyIn then
        cb(false, nil, 'Not enough money')
        return
    end
    
    -- Remove buy-in
    Framework.RemoveMoney(source, minBuyIn, 'cash')
    
    -- Assign seat
    local seat = AssignSeat(tableId, source)
    cb(true, seat, 'Welcome to the table')
end)
```

### Example 2: Player Action

```lua
-- Client
TriggerServerEvent('lxr-poker:server:performAction', tableId, seat, 'raise', 100)

-- Server
RegisterNetEvent('lxr-poker:server:performAction')
AddEventHandler('lxr-poker:server:performAction', function(tableId, seat, action, amount)
    local source = source
    
    -- Validate
    if not ValidateAction(source, tableId, seat, action, amount) then
        return
    end
    
    -- Process action
    ProcessAction(tableId, seat, action, amount)
    
    -- Broadcast to all players
    local playerName = GetPlayerName(source)
    for _, player in pairs(table.players) do
        TriggerClientEvent('lxr-poker:client:playerAction', player.source, tableId, playerName, action, amount)
    end
end)
```

### Example 3: Using Exports

```lua
-- Check if player is gambling before allowing other actions
if exports['lxr-gambling-poker']:IsAtTable() then
    Framework.Notify(nil, 'You cannot do that while playing poker!', 'error', 3000)
    return
end

-- Force player to leave on ban
RegisterCommand('bangambler', function(source, args)
    local target = tonumber(args[1])
    exports['lxr-gambling-poker']:ForceLeaveTable(target, 'Banned from gambling')
end, true)
```

---

## 📚 Event Naming Conventions

### Framework-Specific Events

Events are prefixed by framework:

**LXR-Core:**
```lua
TriggerEvent('lxr-core:client:notify', ...)
TriggerServerEvent('lxr-core:server:event', ...)
```

**RSG-Core:**
```lua
TriggerEvent('RSGCore:Client:Event', ...)
TriggerServerEvent('RSGCore:Server:Event', ...)
```

**VORP:**
```lua
TriggerEvent('vorp:client:event', ...)
TriggerServerEvent('vorp:server:event', ...)
```

### Poker-Specific Events

All poker events use the `lxr-poker:` prefix:
```lua
TriggerClientEvent('lxr-poker:client:event', ...)
TriggerServerEvent('lxr-poker:server:event', ...)
```

---

🐺 **wolves.land** - The Land of Wolves | Where History Lives!
