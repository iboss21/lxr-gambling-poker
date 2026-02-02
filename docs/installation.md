```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Installation Guide
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Installation Guide

Complete step-by-step instructions to install and configure LXR Poker V2.0 on your RedM server.

## 📋 Requirements

### Minimum Requirements
- **RedM Server** version 5848 or higher
- **Game Build** 1355 or higher
- **Framework** (optional but recommended):
  - LXR-Core, RSG-Core, or VORP Core
  - Or standalone mode
- **oxmysql** (optional, for database features)

### Recommended
- **4GB RAM** minimum for server
- **SSD Storage** for better performance
- **Linux Server** for best performance

## 📦 Installation Steps

### Step 1: Download

Download the latest release from:
- [GitHub Releases](https://github.com/iboss21/lxr-gambling-poker/releases)
- Or clone the repository:
  ```bash
  git clone https://github.com/iboss21/lxr-gambling-poker.git
  ```

### Step 2: Extract and Rename

1. Extract the downloaded file
2. **IMPORTANT:** Rename the folder to exactly `lxr-gambling-poker`
3. Place it in your server's `resources` folder

```
your-server/
└── resources/
    └── lxr-gambling-poker/     ← Must be this exact name
        ├── fxmanifest.lua
        ├── config.lua
        ├── client/
        ├── server/
        └── ...
```

**⚠️ The resource name MUST be exactly `lxr-gambling-poker` or it will not work!**

### Step 3: Database Setup (Optional)

If you want to track player statistics and hand history:

#### For oxmysql

Run this SQL in your database:

```sql
-- Player statistics table
CREATE TABLE IF NOT EXISTS `poker_players` (
    `citizenid` VARCHAR(50) PRIMARY KEY,
    `hands_played` INT DEFAULT 0,
    `hands_won` INT DEFAULT 0,
    `total_winnings` INT DEFAULT 0,
    `biggest_pot` INT DEFAULT 0,
    `last_played` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Game history table
CREATE TABLE IF NOT EXISTS `poker_games` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_id` INT NOT NULL,
    `pot` INT NOT NULL,
    `rake` INT DEFAULT 0,
    `players` TEXT,
    `winner` VARCHAR(50),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hand history table
CREATE TABLE IF NOT EXISTS `poker_hands` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `game_id` INT NOT NULL,
    `player_id` VARCHAR(50) NOT NULL,
    `hole_cards` VARCHAR(50),
    `action` VARCHAR(20),
    `amount` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES poker_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Step 4: Configuration

Edit `config.lua` to customize your poker tables:

1. **Set Your Framework** (or leave as 'auto'):
   ```lua
   Config.Framework = 'auto' -- or 'lxr', 'rsg', 'vorp', 'standalone'
   ```

2. **Configure Table Locations:**
   ```lua
   Config.Tables = {
       {
           id = 1,
           name = 'Valentine Saloon Poker',
           location = vector3(-308.38, 778.91, 118.48),
           minBuyIn = 50,
           maxBuyIn = 1000,
           bigBlind = 10,
           smallBlind = 5,
           -- ... more settings
       }
   }
   ```

3. **Set Economy Options:**
   ```lua
   Config.Economy = {
       useMoney = true,
       moneyType = 'cash', -- 'cash' or 'bank'
   }
   ```

See [configuration.md](configuration.md) for all options.

### Step 5: Server.cfg

Add the resource to your `server.cfg`:

```cfg
# LXR Poker V2.0
ensure lxr-gambling-poker
```

**Load Order:**
- Load your framework BEFORE this resource
- Load oxmysql BEFORE this resource (if using database)

Example:
```cfg
# Framework
ensure lxr-core  # or rsg-core, vorp_core

# Database
ensure oxmysql

# Poker
ensure lxr-gambling-poker
```

### Step 6: Permissions (Optional)

Grant admin permissions for table reset:

```cfg
# In server.cfg or permissions file
add_ace group.admin poker.admin allow
```

Or for specific players:
```cfg
add_ace identifier.license:abc123 poker.admin allow
```

### Step 7: Start Server

Start or restart your server:
```bash
restart lxr-gambling-poker
```

Or if first install:
```bash
ensure lxr-gambling-poker
```

### Step 8: Verify Installation

Check console for the boot message:

```
╔════════════════════════════════════════════════════════════╗
║         🐺 LXR POKER V2.0 SYSTEM LOADED 🐺                 ║
╠════════════════════════════════════════════════════════════╣
║  Version:        2.0.0                                     ║
║  Framework:      AUTO-DETECT                               ║
║  Tables:         2 configured                              ║
║  Security:       ENABLED                                   ║
╚════════════════════════════════════════════════════════════╝
```

## ✅ Post-Installation

### Test the System

1. **Join Server** as a player
2. **Check Map** for poker table blips
3. **Approach Table** - should see prompt
4. **Join Table** with buy-in
5. **Test Gameplay** - ensure actions work

### Customize Tables

Add more poker tables by editing `Config.Tables` in `config.lua`:

```lua
{
    id = 3,
    name = 'Blackwater High Roller',
    location = vector3(-813.17, -1324.28, 43.88),
    heading = 90.0,
    blip = {enabled = true, sprite = `blip_poker_table`, name = 'High Roller Poker'},
    minBuyIn = 500,
    maxBuyIn = 10000,
    bigBlind = 100,
    smallBlind = 50,
    houseRake = 0.02, -- 2% rake
}
```

## 🔧 Framework-Specific Setup

### LXR-Core

No additional setup required. The resource will auto-detect.

### RSG-Core

No additional setup required. The resource will auto-detect.

### VORP Core

No additional setup required. The resource will auto-detect.

Optionally, you can add money/item support in VORP config if using items as chips.

### Standalone

If running without a framework:
1. Set `Config.Framework = 'standalone'`
2. Economy features will use simplified system
3. Some framework-specific features may be limited

## ⚙️ Advanced Configuration

### Custom Table Props

Change table/chair models:
```lua
props = {
    table = `your_table_model`,
    chairs = {
        {model = `your_chair_model`, coords = vector3(...), heading = 0.0},
        -- ... more chairs
    }
}
```

### Custom Keys

Change interaction keys in `Config.Keys`:
```lua
Config.Keys = {
    interact = 0x760A9C6F, -- [G] key
    call = 0xC7B5340A,     -- [ENTER] key
    -- ... more keys
}
```

See [RedM Keys Reference](https://github.com/mKeRix/redm-docs/blob/master/controls.md) for key codes.

### Performance Tuning

Adjust update intervals:
```lua
Config.Performance = {
    tableCheckInterval = 1000,  -- How often to check table proximity (ms)
    renderDistance = 50.0,       -- Render props within 50 meters
    interactDistance = 3.0,      -- Show prompts within 3 meters
}
```

## 🐛 Troubleshooting

### Resource Not Starting

**Error:** `Resource lxr-gambling-poker failed to start`

**Solution:**
- Check resource name is exactly `lxr-gambling-poker`
- Verify fxmanifest.lua is present and valid
- Check console for specific error messages

### Framework Not Detected

**Error:** Running in standalone mode when framework is installed

**Solution:**
- Ensure framework resource is started BEFORE poker
- Check framework resource name matches (e.g., 'lxr-core', 'rsg-core')
- Try manually setting `Config.Framework = 'lxr'` (or 'rsg', 'vorp')

### Players Can't Join Tables

**Possible causes:**
- Not enough money for buy-in
- Table is full
- Player too far from table
- Framework not providing money correctly

**Solution:**
- Check player has required money
- Increase Config.Security.maxDistance if needed
- Check framework integration is working

### No Blips on Map

**Solution:**
- Check `blip.enabled = true` in table config
- Verify coordinates are correct
- Restart resource after config changes

### Database Errors

**Error:** Database table doesn't exist

**Solution:**
- Run the SQL schema (see Step 3)
- Ensure oxmysql is running
- Set `Config.Database.enabled = false` if not using database

## 📞 Support

Still having issues?

- 📖 Read the [Configuration Guide](configuration.md)
- 🐛 Check [GitHub Issues](https://github.com/iboss21/lxr-gambling-poker/issues)
- 💬 Join [Discord](https://discord.gg/CrKcWdfd3A) for help

---

🐺 **wolves.land** - The Land of Wolves | Where History Lives!
