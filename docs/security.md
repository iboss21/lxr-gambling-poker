```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Security Guide
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Security Guide

Complete security documentation and best practices for LXR Poker V2.0.

## 🛡️ Security Philosophy

**Never Trust the Client** - All critical operations are validated server-side.

### Core Principles

1. ✅ **Server Authority** - Server is the single source of truth
2. ✅ **Input Validation** - All client data is validated
3. ✅ **Rate Limiting** - Prevent action spam and exploits
4. ✅ **Distance Checks** - Verify player proximity
5. ✅ **Money Validation** - Always check actual balance
6. ✅ **Logging** - Track suspicious activity
7. ✅ **Anti-Cheat** - Detect common exploits

---

## 🔒 Built-in Security Features

### 1. Server-Side Validation

**All critical operations validated server-side:**

```lua
-- ✅ SECURE - Server validates everything
RegisterNetEvent('lxr-poker:server:performAction')
AddEventHandler('lxr-poker:server:performAction', function(tableId, seat, action, amount)
    local source = source
    
    -- Validate player owns this seat
    if not table.players[seat] or table.players[seat].source ~= source then
        return -- Reject
    end
    
    -- Validate it's player's turn
    if table.currentTurn ~= seat then
        return -- Reject
    end
    
    -- Validate bet amount
    if amount > table.players[seat].chips then
        return -- Reject
    end
    
    -- Process action
end)

-- ❌ INSECURE - Never do this!
-- RegisterNetEvent('poker:addMoney')
-- AddEventHandler('poker:addMoney', function(amount)
--     Framework.AddMoney(source, amount) -- Client controls money!
-- end)
```

### 2. Distance Validation

Players must be near tables to interact:

```lua
function ValidateDistance(source, tableId)
    if not Config.Security.validateDistance then 
        return true 
    end
    
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local tableCoords = Config.Tables[tableId].location
    
    local distance = #(playerCoords - tableCoords)
    return distance <= Config.Security.maxDistance
end

-- Usage
if not ValidateDistance(source, tableId) then
    TriggerClientEvent('lxr-poker:client:forceLeave', source, 'Too far from table')
    return
end
```

**Configuration:**
```lua
Config.Security = {
    validateDistance = true,
    maxDistance = 5.0, -- 5 meters
}
```

### 3. Money Validation

Always validate against actual framework balance:

```lua
-- ✅ SECURE
function JoinTable(source, tableId, buyIn)
    -- Check actual balance
    local actualMoney = Framework.GetMoney(source, 'cash')
    
    if actualMoney < buyIn then
        Framework.Notify(source, 'Not enough money', 'error', 3000)
        return false
    end
    
    -- Remove money first
    if not Framework.RemoveMoney(source, buyIn, 'cash') then
        return false
    end
    
    -- Then give chips
    AssignChips(source, buyIn)
    return true
end

-- ❌ INSECURE - Never trust client money values
-- function JoinTable(source, tableId, buyIn, clientMoney)
--     if clientMoney >= buyIn then -- Client sent this value!
--         -- Process...
--     end
-- end
```

### 4. Rate Limiting

Prevent action spam:

```lua
local PlayerActionCounts = {}

function CheckRateLimit(source)
    local currentTime = os.time()
    
    if not PlayerActionCounts[source] then
        PlayerActionCounts[source] = {
            count = 0,
            startTime = currentTime
        }
    end
    
    local tracking = PlayerActionCounts[source]
    
    -- Reset if minute passed
    if currentTime - tracking.startTime >= 60 then
        tracking.count = 0
        tracking.startTime = currentTime
    end
    
    -- Check limit
    if tracking.count >= Config.Security.maxActionsPerMinute then
        if Config.Security.logSuspiciousActivity then
            print('[SECURITY] Player ' .. source .. ' exceeded rate limit')
        end
        return false
    end
    
    tracking.count = tracking.count + 1
    return true
end
```

**Configuration:**
```lua
Config.Security = {
    maxActionsPerMinute = 60,
    actionCooldown = 0.5, -- 0.5s between actions
}
```

### 5. Turn Validation

Ensure it's actually player's turn:

```lua
function ProcessPlayerAction(tableId, seat, source, action)
    local table = PokerTables[tableId]
    
    -- Validate it's this player's turn
    if table.currentTurn ~= seat then
        if Config.Security.logSuspiciousActivity then
            print('[SECURITY] Player ' .. source .. ' acted out of turn')
        end
        return false
    end
    
    -- Validate player owns this seat
    if not table.players[seat] or table.players[seat].source ~= source then
        if Config.Security.logSuspiciousActivity then
            print('[SECURITY] Player ' .. source .. ' claimed wrong seat')
        end
        return false
    end
    
    -- Process action...
end
```

### 6. Anti-Speed Hack

Detect abnormally fast actions:

```lua
local lastActionTime = {}

function DetectSpeedHack(source)
    if not Config.Security.detectSpeedHack then 
        return false 
    end
    
    local currentTime = GetGameTimer()
    local lastTime = lastActionTime[source] or 0
    local timeSinceLastAction = currentTime - lastTime
    
    -- Minimum time between actions
    if timeSinceLastAction < (Config.Security.actionCooldown * 1000) then
        if Config.Security.logSuspiciousActivity then
            print('[SECURITY] Possible speed hack from player ' .. source)
        end
        return true
    end
    
    lastActionTime[source] = currentTime
    return false
end
```

### 7. Suspicious Activity Logging

Log potential exploits:

```lua
function LogSuspiciousActivity(source, reason, data)
    if not Config.Security.logSuspiciousActivity then 
        return 
    end
    
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local playerName = GetPlayerName(source)
    
    local logEntry = string.format(
        '[%s] SECURITY ALERT - Player: %s (ID: %s) - Reason: %s - Data: %s',
        timestamp, playerName, source, reason, json.encode(data)
    )
    
    print(logEntry)
    
    -- Optional: Log to file
    if Config.Security.logToFile then
        -- File logging implementation
    end
    
    -- Optional: Log to Discord
    if Config.Security.logToDiscord and Config.Discord.webhook then
        SendToDiscord(logEntry)
    end
end
```

---

## ⚠️ Common Exploits & Prevention

### Exploit 1: Money Injection

**Attack:** Client tries to manipulate money values.

**Prevention:**
```lua
-- Always check actual balance
local actualMoney = Framework.GetMoney(source, 'cash')

-- Never trust client-provided amounts
-- ❌ Bad: function(source, clientMoney)
-- ✅ Good: function(source) -- Server checks money
```

### Exploit 2: Seat Hijacking

**Attack:** Player tries to claim another player's seat.

**Prevention:**
```lua
-- Validate seat ownership
if table.players[seat].source ~= source then
    LogSuspiciousActivity(source, 'Seat Hijacking Attempt', {tableId, seat})
    return false
end
```

### Exploit 3: Out-of-Turn Actions

**Attack:** Player sends actions when it's not their turn.

**Prevention:**
```lua
-- Validate turn
if table.currentTurn ~= seat then
    LogSuspiciousActivity(source, 'Out of Turn Action', {tableId, seat, action})
    return false
end
```

### Exploit 4: Bet Manipulation

**Attack:** Player tries to bet more chips than they have.

**Prevention:**
```lua
-- Validate chip count
if amount > table.players[seat].chips then
    LogSuspiciousActivity(source, 'Invalid Bet Amount', {tableId, seat, amount, chips})
    return false
end
```

### Exploit 5: Distance Teleporting

**Attack:** Player acts on table while far away.

**Prevention:**
```lua
-- Check distance
if not ValidateDistance(source, tableId) then
    TriggerClientEvent('lxr-poker:client:forceLeave', source, 'Distance check failed')
    LogSuspiciousActivity(source, 'Distance Exploit', {tableId})
    return false
end
```

### Exploit 6: Action Spam

**Attack:** Player spams actions to lag server.

**Prevention:**
```lua
-- Rate limiting
if not CheckRateLimit(source) then
    LogSuspiciousActivity(source, 'Rate Limit Exceeded', {})
    -- Optional: Kick or temp ban
    return false
end
```

---

## 🔧 Security Configuration

### Recommended Production Settings

```lua
Config.Security = {
    -- Core Validation
    validateMoney = true,        -- NEVER disable in production!
    validateDistance = true,      -- Highly recommended
    maxDistance = 5.0,           -- Reasonable range
    
    -- Anti-Cheat
    detectSpeedHack = true,      -- Detect fast actions
    detectMoneyHack = true,      -- Detect impossible amounts
    logSuspiciousActivity = true, -- Log exploits
    
    -- Rate Limiting
    actionCooldown = 0.5,        -- 0.5s between actions
    maxActionsPerMinute = 60,    -- Max 60 actions/min
    
    -- Response Actions
    autoBan = false,             -- Don't auto-ban (false positives possible)
    banDuration = 86400,         -- 24 hours if enabled
    
    -- Logging
    enableLogging = true,        -- Log security events
    logToFile = false,           -- Optional file logging
    logToDiscord = true,         -- Discord webhook alerts
}
```

### Development/Testing Settings

```lua
Config.Security = {
    validateMoney = true,        -- Still validate money
    validateDistance = false,     -- Disable for easier testing
    detectSpeedHack = false,     -- Disable to avoid false positives
    logSuspiciousActivity = true, -- Keep logging for debugging
    maxActionsPerMinute = 120,   -- Higher limit for testing
}
```

**⚠️ Never use development settings in production!**

---

## 📊 Security Monitoring

### Discord Webhook Integration

Log security alerts to Discord:

```lua
Config.Security.logToDiscord = true
Config.Discord.webhook = 'https://discord.com/api/webhooks/...'

-- Webhook format
function SendSecurityAlert(source, reason, data)
    local embed = {
        {
            ['color'] = 15158332, -- Red color
            ['title'] = '🚨 Security Alert',
            ['description'] = reason,
            ['fields'] = {
                {name = 'Player', value = GetPlayerName(source), inline = true},
                {name = 'ID', value = tostring(source), inline = true},
                {name = 'Details', value = json.encode(data), inline = false},
            },
            ['footer'] = {text = 'LXR Poker Security'},
            ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%S'),
        }
    }
    
    PerformHttpRequest(Config.Discord.webhook, function() end, 'POST', 
        json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end
```

### File Logging

Log to file for analysis:

```lua
-- In server console
setr poker:logfile "poker_security.log"

-- Implementation
function LogToFile(message)
    local file = io.open(GetConvar('poker:logfile', 'poker.log'), 'a')
    if file then
        file:write(os.date('%Y-%m-%d %H:%M:%S') .. ' ' .. message .. '\n')
        file:close()
    end
end
```

---

## 🎯 Security Best Practices

### For Server Owners

1. ✅ **Keep Updated** - Update resource regularly for security patches
2. ✅ **Enable Validation** - Never disable security features in production
3. ✅ **Monitor Logs** - Review security logs regularly
4. ✅ **Use Webhooks** - Set up Discord alerts for real-time monitoring
5. ✅ **Test Thoroughly** - Test all features before production deployment
6. ✅ **Backup Data** - Regular database backups
7. ✅ **Secure Framework** - Ensure framework is also secured

### For Developers

1. ✅ **Server Authority** - All game logic on server
2. ✅ **Input Validation** - Validate all client input
3. ✅ **Rate Limiting** - Prevent spam and DoS
4. ✅ **Distance Checks** - Validate player proximity
5. ✅ **Money Validation** - Always check actual balance
6. ✅ **Logging** - Log suspicious activity
7. ✅ **Code Review** - Review security implications of changes

### Security Checklist

- [ ] `Config.Security.validateMoney = true`
- [ ] `Config.Security.validateDistance = true`
- [ ] `Config.Security.detectSpeedHack = true`
- [ ] `Config.Security.logSuspiciousActivity = true`
- [ ] Discord webhook configured
- [ ] ACE permissions set for admin commands
- [ ] Framework security features enabled
- [ ] Regular log monitoring scheduled
- [ ] Backup system in place
- [ ] Resource up to date

---

## 🆘 Responding to Security Incidents

### If Exploit Detected

1. **Identify** - Check logs for player ID and exploit type
2. **Verify** - Confirm it's not a false positive
3. **Document** - Save logs and evidence
4. **Act** - Kick/ban if confirmed
5. **Fix** - Update config or report issue
6. **Monitor** - Watch for repeat attempts

### Example Response

```lua
-- Detect exploit
LogSuspiciousActivity(source, 'Money Hack Detected', {
    reportedMoney = clientMoney,
    actualMoney = serverMoney,
    difference = clientMoney - serverMoney
})

-- Kick player
DropPlayer(source, 'Security violation: Money manipulation detected')

-- Ban if enabled
if Config.Security.autoBan then
    -- Add to ban list
    BanPlayer(source, Config.Security.banDuration)
end

-- Alert admins
SendToDiscord('Security Incident', {
    player = GetPlayerName(source),
    reason = 'Money hack detected',
    action = 'Kicked and banned'
})
```

---

## 📚 Further Reading

- [Configuration Guide](configuration.md) - Security settings
- [Events Reference](events.md) - Secure event handling
- [Performance Guide](performance.md) - Performance vs security balance

---

🐺 **wolves.land** - The Land of Wolves | Where History Lives!
