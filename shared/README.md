```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Shared Scripts
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Shared Scripts

This folder contains **shared scripts** loaded on both client and server.

## 📁 Contents

- **framework.lua** - Multi-framework adapter layer
  - Framework detection (auto)
  - Unified API for all frameworks
  - Player data functions
  - Money functions
  - Notification system
  - Callback system
  
- **locale.lua** - Translation system
  - Multi-language support
  - Dynamic language switching
  - Translation key management

## 🎯 Framework Adapter

The framework adapter provides a **unified API** that works across:

- **LXR-Core** (Primary)
- **RSG-Core** (Primary)
- **VORP Core** (Supported)
- **Standalone** (Fallback)

### Example Usage

```lua
-- Get player data (works on any framework)
local PlayerData = Framework.GetPlayerData(source)

-- Get player money
local cash = Framework.GetMoney(source, 'cash')

-- Add money
Framework.AddMoney(source, 100, 'cash')

-- Notify player
Framework.Notify(source, 'You won!', 'success', 5000)
```

## 🌍 Localization

The locale system allows easy translation:

```lua
-- Get translated text
local text = L('your_turn')

-- With parameters
local text = L('player_won', playerName, amount)
```

---

🐺 **wolves.land** - The Land of Wolves
