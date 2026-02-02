```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Framework Integration
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Framework Integration

Complete guide to multi-framework support and the Framework Adapter Layer.

## 🔄 Supported Frameworks

LXR Poker V2.0 supports **automatic detection** and integration with multiple RedM frameworks:

### Priority Order

1. **LXR-Core** (Primary) - wolves.land framework
2. **RSG-Core** (Primary) - Popular RedM framework  
3. **VORP Core** (Supported) - Legacy framework
4. **Standalone** (Fallback) - No framework required

## 🏗️ Framework Adapter Layer

The **Framework Adapter** (`shared/framework.lua`) provides a **unified API** that works identically across all frameworks. Your scripts call the same functions regardless of which framework is running.

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│           Your Poker Scripts (Client/Server)            │
│         (Calls unified Framework.* functions)           │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│              Framework Adapter Layer                    │
│          (Detects framework & translates calls)         │
└─────────────────────────────────────────────────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │ LXR-Core │    │ RSG-Core │    │   VORP   │
    └──────────┘    └──────────┘    └──────────┘
```

## 🎯 Unified API Functions

### Player Data Functions

#### `Framework.GetPlayerData(source)`

Get player data (works on client and server).

**Parameters:**
- `source` (number) - Player source ID (server-side only)

**Returns:** Player data table

**Example:**
```lua
-- Server-side
local PlayerData = Framework.GetPlayerData(source)
print(PlayerData.citizenid)

-- Client-side
local PlayerData = Framework.GetPlayerData()
print(PlayerData.citizenid)
```

#### `Framework.GetMoney(source, moneyType)`

Get player's money amount.

**Parameters:**
- `source` (number) - Player source ID
- `moneyType` (string) - `'cash'` or `'bank'`

**Returns:** number (money amount)

**Example:**
```lua
local cash = Framework.GetMoney(source, 'cash')
if cash >= 100 then
    print("Player has enough money")
end
```

#### `Framework.AddMoney(source, amount, moneyType)`

Add money to player account.

**Parameters:**
- `source` (number) - Player source ID
- `amount` (number) - Amount to add
- `moneyType` (string) - `'cash'` or `'bank'`

**Returns:** boolean (success)

**Example:**
```lua
local success = Framework.AddMoney(source, 500, 'cash')
if success then
    print("Added $500 to player")
end
```

#### `Framework.RemoveMoney(source, amount, moneyType)`

Remove money from player account.

**Parameters:**
- `source` (number) - Player source ID
- `amount` (number) - Amount to remove
- `moneyType` (string) - `'cash'` or `'bank'`

**Returns:** boolean (success)

**Example:**
```lua
local success = Framework.RemoveMoney(source, 100, 'cash')
if success then
    print("Removed $100 from player")
end
```

### Notification Functions

#### `Framework.Notify(source, message, type, duration)`

Show notification to player.

**Parameters:**
- `source` (number) - Player source (server) or nil (client)
- `message` (string) - Notification text
- `type` (string) - `'success'`, `'error'`, `'info'`, `'warning'`
- `duration` (number) - Duration in milliseconds

**Example:**
```lua
-- Server-side
Framework.Notify(source, 'You won the pot!', 'success', 5000)

-- Client-side
Framework.Notify(nil, 'Your turn!', 'info', 3000)
```

### Callback Functions

#### `Framework.CreateCallback(name, callback)` (Server)

Register a server callback.

**Parameters:**
- `name` (string) - Callback identifier
- `callback` (function) - Callback function

**Example:**
```lua
Framework.CreateCallback('poker:getPlayerMoney', function(source, cb)
    local money = Framework.GetMoney(source, 'cash')
    cb(money)
end)
```

#### `Framework.TriggerCallback(name, callback, ...)` (Client)

Trigger server callback from client.

**Parameters:**
- `name` (string) - Callback identifier
- `callback` (function) - Response handler
- `...` - Arguments to pass

**Example:**
```lua
Framework.TriggerCallback('poker:getPlayerMoney', function(money)
    print("Player has: $" .. money)
end)
```

### Admin Functions

#### `Framework.HasPermission(source, permission)`

Check if player has permission.

**Parameters:**
- `source` (number) - Player source ID
- `permission` (string) - Permission string

**Returns:** boolean

**Example:**
```lua
if Framework.HasPermission(source, 'poker.admin') then
    print("Player is admin")
end
```

## 🔧 Framework-Specific Details

### LXR-Core Integration

**Resource Name:** `lxr-core`

**Events:**
- `lxr-core:client:*` - Client events
- `lxr-core:server:*` - Server events
- `lxr-core:callback:*` - Callbacks

**Configuration:**
```lua
Config.FrameworkSettings['lxr'] = {
    resourceName = 'lxr-core',
    callbackPrefix = 'lxr-core:callback:',
    clientPrefix = 'lxr-core:client:',
    serverPrefix = 'lxr-core:server:',
    getCoreObject = function()
        return exports['lxr-core']:GetCoreObject()
    end
}
```

**Getting Core Object:**
```lua
local LXRCore = exports['lxr-core']:GetCoreObject()
```

### RSG-Core Integration

**Resource Name:** `rsg-core`

**Events:**
- `RSGCore:Client:*` - Client events
- `RSGCore:Server:*` - Server events
- `RSGCore:Callback:*` - Callbacks

**Configuration:**
```lua
Config.FrameworkSettings['rsg'] = {
    resourceName = 'rsg-core',
    callbackPrefix = 'RSGCore:Callback:',
    clientPrefix = 'RSGCore:Client:',
    serverPrefix = 'RSGCore:Server:',
    getCoreObject = function()
        return exports['rsg-core']:GetCoreObject()
    end
}
```

**Getting Core Object:**
```lua
local RSGCore = exports['rsg-core']:GetCoreObject()
```

### VORP Core Integration

**Resource Name:** `vorp_core`

**Events:**
- `vorp:client:*` - Client events
- `vorp:server:*` - Server events
- `vorp:SelectedCharacter` - Character selection

**Configuration:**
```lua
Config.FrameworkSettings['vorp'] = {
    resourceName = 'vorp_core',
    callbackPrefix = 'vorp:callback:',
    clientPrefix = 'vorp:client:',
    serverPrefix = 'vorp:server:',
    getCoreObject = function()
        return exports.vorp_core:GetCore()
    end
}
```

**Getting Core Object:**
```lua
local VORPcore = exports.vorp_core:GetCore()
```

**Special Note:** VORP requires waiting for character selection:
```lua
RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function(charid)
    -- Player character is now loaded
end)
```

### Standalone Mode

When no framework is detected, the system runs in **standalone mode** with simplified functionality:

- Money transactions use placeholder values
- No job/character data
- Basic notification system
- Suitable for testing or non-RP servers

## 🔍 Framework Detection

### Automatic Detection

By default, the system automatically detects your framework:

```lua
Config.Framework = 'auto'
```

Detection order:
1. Checks for `lxr-core` resource
2. Checks for `rsg-core` resource
3. Checks for `vorp_core` resource
4. Falls back to standalone

### Manual Override

You can manually specify the framework:

```lua
Config.Framework = 'lxr'  -- Force LXR-Core
Config.Framework = 'rsg'  -- Force RSG-Core
Config.Framework = 'vorp' -- Force VORP
Config.Framework = 'standalone' -- Force standalone
```

### Detection Code

```lua
function Framework.Detect()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
    if GetResourceState('lxr-core') == 'started' then
        return 'lxr'
    elseif GetResourceState('rsg-core') == 'started' then
        return 'rsg'
    elseif GetResourceState('vorp_core') == 'started' then
        return 'vorp'
    else
        return 'standalone'
    end
end
```

## 🛠️ Adding Custom Framework Support

Want to add support for another framework? Edit `shared/framework.lua`:

### Step 1: Add Framework Config

```lua
Config.FrameworkSettings['myframework'] = {
    resourceName = 'my-framework',
    callbackPrefix = 'myfw:callback:',
    clientPrefix = 'myfw:client:',
    serverPrefix = 'myfw:server:',
    getCoreObject = function()
        return exports['my-framework']:GetCore()
    end
}
```

### Step 2: Add Detection

```lua
function Framework.Detect()
    -- ... existing code ...
    
    if GetResourceState('my-framework') == 'started' then
        return 'myframework'
    end
    
    -- ... fallback ...
end
```

### Step 3: Implement Functions

Add your framework's specific logic to each function:

```lua
function Framework.GetMoney(source, moneyType)
    -- ... existing frameworks ...
    
    elseif Framework.Type == 'myframework' then
        local Core = Framework.GetCoreObject()
        local Player = Core.GetPlayer(source)
        return Player.getMoney(moneyType)
    end
end
```

## 🧪 Testing Framework Integration

### Test on Each Framework

1. Install framework
2. Start poker resource
3. Check console for detection message:
   ```
   [LXR Poker] LXR-Core detected!
   ```
4. Test money transactions
5. Test notifications
6. Test callbacks

### Common Issues

**Framework not detected:**
- Ensure framework starts BEFORE poker resource
- Check resource names match exactly
- Verify framework is actually running

**Money transactions fail:**
- Check player has enough money
- Verify framework's money functions work
- Check console for errors

**Callbacks don't work:**
- Verify framework supports callbacks
- Check callback prefix is correct
- Ensure proper syntax for your framework

## 📚 Further Reading

- [Configuration Guide](configuration.md) - Framework settings
- [Events Reference](events.md) - Event naming conventions
- [Security Guide](security.md) - Framework-specific security

---

🐺 **wolves.land** - The Land of Wolves | Where History Lives!
