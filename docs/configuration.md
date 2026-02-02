```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Configuration Reference
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Configuration Reference

Complete reference for all configuration options in `config.lua`.

## 📋 Table of Contents

- [Framework Configuration](#framework-configuration)
- [Language Configuration](#language-configuration)
- [General Settings](#general-settings)
- [Poker Tables](#poker-tables)
- [Economy Settings](#economy-settings)
- [Game Rules](#game-rules)
- [Animations & Props](#animations--props)
- [Interaction Keys](#interaction-keys)
- [Notifications](#notifications)
- [Security & Anti-Cheat](#security--anti-cheat)
- [Performance Optimization](#performance-optimization)
- [Debug Settings](#debug-settings)
- [Database Configuration](#database-configuration)
- [Discord Integration](#discord-integration)

---

## Framework Configuration

### `Config.Framework`

Framework detection mode.

**Type:** `string`  
**Default:** `'auto'`  
**Options:** `'auto'`, `'lxr'`, `'rsg'`, `'vorp'`, `'standalone'`

```lua
Config.Framework = 'auto' -- Automatic detection (recommended)
```

### `Config.FrameworkSettings`

Framework-specific configuration for each supported framework.

```lua
Config.FrameworkSettings = {
    ['lxr'] = {
        resourceName = 'lxr-core',
        callbackPrefix = 'lxr-core:callback:',
        -- ... framework-specific settings
    },
    -- ... other frameworks
}
```

---

## Language Configuration

### `Config.Lang`

Default language for translations.

**Type:** `string`  
**Default:** `'en'`  
**Options:** `'en'`, `'ka'`, `'es'`, `'fr'`, etc.

```lua
Config.Lang = 'en' -- English
```

Add more languages by creating files in `locales/` folder.

---

## General Settings

### `Config.General`

General poker system settings.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `gameType` | string | `'holdem'` | Poker variant (Texas Hold'em) |
| `useNativeUI` | boolean | `true` | Use native RDR2 poker UI |
| `maxPlayers` | number | `6` | Maximum players per table |
| `allowSpectators` | boolean | `true` | Enable spectator mode |
| `maxSpectators` | number | `4` | Maximum spectators per table |
| `enableDealers` | boolean | `true` | Spawn NPC dealers |
| `enableNPCPlayers` | boolean | `true` | Allow NPC players (AI) |
| `maxNPCPlayers` | number | `5` | Maximum NPCs per table |
| `adminResetCommand` | string | `'poker_reset'` | Command to reset tables |
| `adminAcePermission` | string | `'poker.admin'` | ACE permission required |

```lua
Config.General = {
    maxPlayers = 6,
    allowSpectators = true,
    enableDealers = true,
    -- ...
}
```

---

## Poker Tables

### `Config.Tables`

Array of poker table configurations.

Each table must have:

| Field | Type | Description |
|-------|------|-------------|
| `id` | number | Unique table identifier |
| `name` | string | Table display name |
| `location` | vector3 | Table coordinates |
| `heading` | number | Table rotation (0-360) |
| `blip` | table | Blip configuration |
| `props` | table | Props (table, chairs, dealer) |
| `minBuyIn` | number | Minimum buy-in amount |
| `maxBuyIn` | number | Maximum buy-in amount |
| `bigBlind` | number | Big blind amount |
| `smallBlind` | number | Small blind amount |
| `houseRake` | number | House commission (0.0-1.0) |

**Example:**

```lua
Config.Tables = {
    {
        id = 1,
        name = 'Valentine Saloon Poker',
        location = vector3(-308.38, 778.91, 118.48),
        heading = 180.0,
        blip = {
            enabled = true,
            sprite = `blip_poker_table`,
            name = 'Poker Table',
            scale = 0.2
        },
        props = {
            table = `p_tablecards01x`,
            chairs = {
                {model = `p_chair05x`, coords = vector3(-308.38, 780.41, 118.48), heading = 0.0},
                -- ... 5 more chairs
            },
            dealer = {
                model = `u_m_m_sdcardgambler_01`,
                coords = vector3(-308.38, 778.91, 118.48),
                heading = 90.0
            }
        },
        minBuyIn = 50,
        maxBuyIn = 1000,
        bigBlind = 10,
        smallBlind = 5,
        houseRake = 0.05, -- 5% rake
    },
}
```

---

## Economy Settings

### `Config.Economy`

Currency and transaction settings.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `useMoney` | boolean | `true` | Use money for bets |
| `useItems` | boolean | `false` | Use items as chips |
| `moneyType` | string | `'cash'` | Money account type |
| `moneyAccount` | string | `'cash'` | Account name |
| `chipItem` | string | `'poker_chip'` | Item name if using items |
| `chipValue` | number | `1` | Value per chip |
| `payoutMethod` | string | `'instant'` | `'instant'` or `'delayed'` |
| `payoutDelay` | number | `5` | Delay in seconds |

```lua
Config.Economy = {
    useMoney = true,
    moneyType = 'cash',
    -- ...
}
```

---

## Game Rules

### `Config.GameRules`

Poker gameplay rules.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `minRaise` | string | `'bigBlind'` | Minimum raise amount |
| `allowAllIn` | boolean | `true` | Allow all-in bets |
| `allowSidePots` | boolean | `true` | Enable side pot mechanics |
| `turnTimer` | number | `60` | Seconds per turn |
| `warnAt` | number | `15` | Warning at X seconds |
| `dealerRotation` | boolean | `true` | Rotate dealer button |

```lua
Config.GameRules = {
    turnTimer = 60,
    allowAllIn = true,
    -- ...
}
```

---

## Animations & Props

### `Config.Animations`

Animation dictionaries and names.

```lua
Config.Animations = {
    sitting = {
        dict = 'script_re@poker@@seated@player@',
        anim = 'idle',
        flag = 1,
    },
    betting = {
        dict = 'script_re@poker@@seated@player@bet',
        anim = 'bet',
        flag = 48,
    },
    -- ... more animations
}
```

### `Config.Props`

Prop models for chips and cards.

```lua
Config.Props = {
    chips = `p_chipsstack01x`,
    cards = `p_cards01x`,
}
```

---

## Interaction Keys

### `Config.Keys`

Key bindings for poker actions.

See [RedM Controls Reference](https://github.com/mKeRix/redm-docs/blob/master/controls.md) for key codes.

| Action | Default Key | Hash |
|--------|-------------|------|
| `interact` | G | `0x760A9C6F` |
| `call` | ENTER | `0xC7B5340A` |
| `raise` | R | `0x07B8BEAF` |
| `fold` | F | `0x8FD015D8` |
| `allIn` | A | `0xD9D0E1C0` |
| `check` | SPACE | `0x156F7119` |

```lua
Config.Keys = {
    interact = 0x760A9C6F, -- [G]
    call = 0xC7B5340A,     -- [ENTER]
    -- ...
}
```

---

## Notifications

### `Config.Notifications`

Notification system settings.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `type` | string | `'native'` | `'native'`, `'framework'`, `'custom'` |

```lua
Config.Notifications = {
    type = 'native', -- Use native RDR2 notifications
    native = {
        dict = 'ITEMTYPE_TEXTURES',
        texture = 'poker_chip',
        duration = 5000,
    }
}
```

---

## Security & Anti-Cheat

### `Config.Security`

Security validation and anti-cheat settings.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `validateMoney` | boolean | `true` | Validate player money server-side |
| `validateDistance` | boolean | `true` | Check player distance to table |
| `maxDistance` | number | `5.0` | Maximum distance (meters) |
| `detectSpeedHack` | boolean | `true` | Detect abnormal speeds |
| `detectMoneyHack` | boolean | `true` | Detect impossible amounts |
| `logSuspiciousActivity` | boolean | `true` | Log suspicious actions |
| `actionCooldown` | number | `0.5` | Cooldown between actions (seconds) |
| `maxActionsPerMinute` | number | `60` | Max actions per minute |
| `autoBan` | boolean | `false` | Auto-ban on cheat detection |
| `enableLogging` | boolean | `true` | Enable security logging |

```lua
Config.Security = {
    validateMoney = true,
    validateDistance = true,
    maxDistance = 5.0,
    -- ...
}
```

**⚠️ Important:** Never disable `validateMoney` in production!

---

## Performance Optimization

### `Config.Performance`

Performance tuning settings.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `blipUpdateInterval` | number | `5000` | Update blips every X ms |
| `tableCheckInterval` | number | `1000` | Check table proximity every X ms |
| `stateUpdateInterval` | number | `500` | Update game state every X ms |
| `cacheFramework` | boolean | `true` | Cache framework object |
| `cachePlayers` | boolean | `true` | Cache player data |
| `cacheTimeout` | number | `60` | Cache timeout (seconds) |
| `renderDistance` | number | `50.0` | Render props within X meters |
| `interactDistance` | number | `3.0` | Show prompts within X meters |
| `autoCleanup` | boolean | `true` | Auto-cleanup resources |
| `cleanupInterval` | number | `300` | Cleanup every X seconds |

```lua
Config.Performance = {
    tableCheckInterval = 1000,
    renderDistance = 50.0,
    interactDistance = 3.0,
    -- ...
}
```

---

## Debug Settings

### `Config.Debug`

Debug and development settings.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enabled` | boolean | `false` | Enable debug mode |
| `printToConsole` | boolean | `true` | Print to server console |
| `printToChat` | boolean | `false` | Print to player chat |
| `showCoords` | boolean | `false` | Show coordinates on screen |
| `showState` | boolean | `false` | Show game state on screen |
| `logEvents` | boolean | `false` | Log all events |
| `logCallbacks` | boolean | `false` | Log all callbacks |

```lua
Config.Debug = {
    enabled = false, -- Disable in production!
}
```

**⚠️ Never enable debug mode in production!**

---

## Database Configuration

### `Config.Database`

Database integration settings.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enabled` | boolean | `true` | Enable database features |
| `useOxMySQL` | boolean | `true` | Use oxmysql |
| `trackStats` | boolean | `true` | Track player statistics |
| `trackHands` | boolean | `true` | Save hand history |

```lua
Config.Database = {
    enabled = true,
    trackStats = true,
    tables = {
        players = 'poker_players',
        games = 'poker_games',
        hands = 'poker_hands',
    }
}
```

---

## Discord Integration

### `Config.Discord`

Discord webhook logging.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enabled` | boolean | `false` | Enable Discord logging |
| `webhook` | string | `''` | Discord webhook URL |
| `logWins` | boolean | `true` | Log big wins |
| `logGames` | boolean | `true` | Log game start/end |
| `logHighStakes` | boolean | `true` | Log high stakes games |
| `highStakesThreshold` | number | `1000` | Threshold for high stakes |

```lua
Config.Discord = {
    enabled = false,
    webhook = 'https://discord.com/api/webhooks/...',
    logWins = true,
}
```

---

## 🎯 Configuration Best Practices

### Production Settings

For live servers:
- ✅ `Config.Debug.enabled = false`
- ✅ `Config.Security.validateMoney = true`
- ✅ `Config.Security.validateDistance = true`
- ✅ `Config.Security.logSuspiciousActivity = true`
- ✅ `Config.Performance.cacheFramework = true`

### Development Settings

For testing:
- ✅ `Config.Debug.enabled = true`
- ✅ Lower buy-ins for easy testing
- ✅ Shorter turn timers for faster testing
- ⚠️ Never use dev settings in production!

### Performance Tuning

For high-player-count servers:
- Increase `tableCheckInterval` to 2000-3000ms
- Increase `blipUpdateInterval` to 10000ms
- Decrease `renderDistance` if needed

### Security Hardening

For maximum security:
- Enable all validation options
- Set `autoBan = true` (with caution)
- Enable logging
- Set up Discord webhooks

---

🐺 **wolves.land** - The Land of Wolves | Where History Lives!
