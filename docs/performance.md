```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Performance Guide
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Performance Guide

Optimization guide for maximum performance on production servers.

## 🎯 Performance Targets

- **Idle (no players nearby):** 0.00ms
- **Active (players at table):** <0.05ms per table
- **Peak (full server, all tables active):** <0.50ms total

---

## 📊 Performance Metrics

### Baseline Performance

On a properly configured server:

| Scenario | Client ms/tick | Server ms/tick |
|----------|----------------|----------------|
| No players near tables | 0.00ms | 0.00ms |
| 1 player near table | 0.01ms | 0.01ms |
| 6 players at table | 0.05ms | 0.03ms |
| All tables active | 0.10ms | 0.08ms |

---

## ⚡ Optimization Features

### 1. Smart Thread Management

**Proximity-Based Updates:**

```lua
Citizen.CreateThread(function()
    while true do
        local sleep = Config.Performance.tableCheckInterval
        local playerCoords = GetPlayerCoords()
        local nearTable = false
        
        for tableId, table in ipairs(Config.Tables) do
            local distance = GetDistance(playerCoords, table.location)
            
            if distance <= Config.Performance.interactDistance then
                nearTable = true
                -- Show prompts and check interactions
            end
        end
        
        if not nearTable then
            sleep = 2000 -- Increase sleep when not near any table
        end
        
        Wait(sleep)
    end
end)
```

**Benefits:**
- 0.00ms when player is far from tables
- Only active when player nearby
- Configurable check intervals

### 2. Distance-Based Rendering

Props only render within range:

```lua
Config.Performance = {
    renderDistance = 50.0,  -- Render props within 50m
    interactDistance = 3.0, -- Show prompts within 3m
}

-- Implementation
if distance <= Config.Performance.renderDistance then
    -- Render props
else
    -- Don't render
end
```

### 3. Caching System

Framework and player data cached to reduce lookups:

```lua
-- Cache framework object
if Config.Performance.cacheFramework then
    if not Framework.Core then
        Framework.Core = Framework.GetCoreObject()
    end
end

-- Cache player data
if Config.Performance.cachePlayers then
    if not cachedPlayerData or (os.time() - lastCache) > Config.Performance.cacheTimeout then
        cachedPlayerData = Framework.GetPlayerData()
        lastCache = os.time()
    end
end
```

**Configuration:**
```lua
Config.Performance = {
    cacheFramework = true,
    cachePlayers = true,
    cacheTimeout = 60, -- Refresh every 60 seconds
}
```

### 4. Statebag Synchronization

Efficient state sync using statebags:

```lua
-- Instead of constant triggers:
-- TriggerClientEvent('update', -1, data) -- Every update

-- Use statebags:
Entity(table).state:set('pokerData', data, true)

-- Clients listen once:
AddStateBagChangeHandler('pokerData', nil, function(bagName, key, value)
    -- Handle update
end)
```

### 5. Event Throttling

Limit event frequency:

```lua
local lastUpdate = 0
local updateThrottle = 500 -- 500ms

function UpdateGameState()
    local currentTime = GetGameTimer()
    
    if currentTime - lastUpdate < updateThrottle then
        return -- Skip update
    end
    
    lastUpdate = currentTime
    -- Send update
end
```

### 6. Efficient Loops

Avoid constant iterations:

```lua
-- ❌ Bad: Iterating all players every tick
Citizen.CreateThread(function()
    while true do
        Wait(0) -- Every tick!
        for _, player in ipairs(GetPlayers()) do
            -- Check something
        end
    end
end)

-- ✅ Good: Event-driven or timed checks
RegisterNetEvent('poker:playerNearby')
AddEventHandler('poker:playerNearby', function(playerId)
    -- Handle specific player
end)
```

---

## ⚙️ Configuration Tuning

### Low-End Servers (16-32 players)

Optimize for lower player counts:

```lua
Config.Performance = {
    blipUpdateInterval = 5000,
    tableCheckInterval = 1000,
    stateUpdateInterval = 500,
    renderDistance = 50.0,
    interactDistance = 3.0,
    cacheFramework = true,
    cachePlayers = true,
    cacheTimeout = 60,
}
```

### High-End Servers (64+ players)

Optimize for high player counts:

```lua
Config.Performance = {
    blipUpdateInterval = 10000,  -- Less frequent blip updates
    tableCheckInterval = 2000,   -- Longer check intervals
    stateUpdateInterval = 1000,  -- Slower state updates
    renderDistance = 40.0,       -- Shorter render distance
    interactDistance = 2.5,      -- Closer interaction distance
    cacheFramework = true,
    cachePlayers = true,
    cacheTimeout = 30,          -- Shorter cache (more current data)
}
```

### Budget Servers (Limited Resources)

Maximum optimization:

```lua
Config.Performance = {
    blipUpdateInterval = 15000,
    tableCheckInterval = 3000,
    stateUpdateInterval = 1500,
    renderDistance = 30.0,
    interactDistance = 2.0,
    cacheFramework = true,
    cachePlayers = true,
    cacheTimeout = 120,
    autoCleanup = true,
    cleanupInterval = 180, -- Cleanup every 3 minutes
}
```

---

## 📈 Monitoring Performance

### Using txAdmin

1. Open txAdmin dashboard
2. Go to **Server** → **Resources**
3. Find `lxr-gambling-poker`
4. Check:
   - CPU usage
   - Memory usage
   - Thread count
   - Tick time

### Using In-Game Commands

```lua
-- Enable profiler
profiler record start

-- Wait 60 seconds

-- Stop and view
profiler record stop
profiler view
```

### Console Monitoring

```lua
-- Enable debug mode
Config.Debug.enabled = true

-- View performance metrics in console
[LXR Poker] Table check: 0.01ms
[LXR Poker] State update: 0.02ms
[LXR Poker] Total: 0.03ms
```

---

## 🔧 Performance Troubleshooting

### High Client ms/tick

**Symptoms:**
- Client FPS drops near tables
- Stuttering when interacting

**Solutions:**
1. Increase `tableCheckInterval`
2. Decrease `renderDistance`
3. Reduce prop density
4. Check for conflicting resources

```lua
-- Try these settings
Config.Performance.tableCheckInterval = 2000
Config.Performance.renderDistance = 30.0
```

### High Server ms/tick

**Symptoms:**
- Server lag spikes
- Delayed actions
- High CPU usage

**Solutions:**
1. Increase `stateUpdateInterval`
2. Enable more caching
3. Reduce table count
4. Check database performance

```lua
Config.Performance.stateUpdateInterval = 1000
Config.Performance.cachePlayers = true
```

### Memory Leaks

**Symptoms:**
- Memory usage grows over time
- Server restarts needed

**Solutions:**
1. Enable auto-cleanup
2. Reduce cache timeout
3. Check for prop deletion
4. Monitor spawned entities

```lua
Config.Performance.autoCleanup = true
Config.Performance.cleanupInterval = 300
```

### Database Slowdowns

**Symptoms:**
- Slow joins/leaves
- Delayed statistics updates

**Solutions:**
1. Add database indexes
2. Use connection pooling
3. Reduce tracked data
4. Disable features if not needed

```sql
-- Add indexes
CREATE INDEX idx_citizenid ON poker_players(citizenid);
CREATE INDEX idx_game_id ON poker_hands(game_id);
```

```lua
-- Disable if not needed
Config.Database.trackStats = false
Config.Database.trackHands = false
```

---

## 💡 Best Practices

### Resource Management

```lua
-- ✅ Good: Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Delete spawned props
    for _, prop in ipairs(spawnedProps) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    
    -- Clear animations
    ClearPedTasks(PlayerPedId())
end)
```

### Efficient Natives

```lua
-- ❌ Slow: Multiple calls
local x, y, z = table.unpack(GetEntityCoords(ped))

-- ✅ Fast: Single call
local coords = GetEntityCoords(ped)
```

### Batch Operations

```lua
-- ❌ Slow: Individual triggers
for _, player in ipairs(players) do
    TriggerClientEvent('update', player.source, data)
end

-- ✅ Fast: Batch trigger
TriggerClientEvent('update', -1, data) -- All clients at once
```

### Event Usage

```lua
-- ❌ Slow: Constant polling
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, key) then
            -- Do something
        end
    end
end)

-- ✅ Fast: RegisterKeyMapping (FiveM) or smarter polling
Citizen.CreateThread(function()
    while true do
        Wait(100) -- Don't check every tick
        if isAtTable and IsControlJustPressed(0, key) then
            -- Do something
        else
            Wait(500) -- Sleep longer when not at table
        end
    end
end)
```

---

## 📊 Performance Checklist

### Before Production

- [ ] Tested with maximum players at tables
- [ ] Verified 0.00ms idle performance
- [ ] Checked memory usage over time
- [ ] Profiled with txAdmin
- [ ] Optimized configuration for server specs
- [ ] Disabled debug mode
- [ ] Enabled caching features
- [ ] Tested database performance
- [ ] Verified no memory leaks
- [ ] Checked CPU usage under load

### Regular Maintenance

- [ ] Monitor performance weekly
- [ ] Check logs for performance warnings
- [ ] Review player feedback
- [ ] Update configuration as needed
- [ ] Clean up old database records
- [ ] Verify cache effectiveness
- [ ] Check for resource conflicts

---

## 🎯 Performance vs Features

Some features have performance costs:

| Feature | Performance Impact | Recommendation |
|---------|-------------------|----------------|
| Statistics Tracking | Low | Keep enabled |
| Hand History | Medium | Disable if not needed |
| Discord Logging | Low | Keep if wanted |
| NPC Players | Medium | Limit count |
| Debug Mode | High | **Disable in production!** |
| Spectator Mode | Low | Keep enabled |
| Distance Validation | Very Low | **Always enabled** |

---

## 📚 Further Reading

- [Configuration Guide](configuration.md) - Performance settings
- [Security Guide](security.md) - Security vs performance
- [Overview](overview.md) - System architecture

---

🐺 **wolves.land** - The Land of Wolves | Where History Lives!
