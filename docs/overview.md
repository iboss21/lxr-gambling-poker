```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - System Overview
════════════════════════════════════════════════════════════════════════════════════════════════
```

# System Overview

## 📋 Introduction

**LXR Poker V2.0** is a professional-grade Texas Hold'em poker system built specifically for RedM servers. It combines authentic Wild West gambling mechanics with modern security practices and performance optimization.

## 🏗️ Architecture

### Three-Layer Design

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                         │
│  • Player Interactions    • Animations & Props          │
│  • UI Display            • Proximity Detection          │
└─────────────────────────────────────────────────────────┘
                           ▲ │
                           │ ▼
┌─────────────────────────────────────────────────────────┐
│                    SHARED LAYER                         │
│  • Framework Adapter     • Localization System          │
│  • Unified API           • Config Management            │
└─────────────────────────────────────────────────────────┘
                           ▲ │
                           │ ▼
┌─────────────────────────────────────────────────────────┐
│                    SERVER LAYER                         │
│  • Game State Logic      • Security Validation          │
│  • Turn Management       • Economy Handling             │
│  • Hand Evaluation       • Database Operations          │
└─────────────────────────────────────────────────────────┘
```

### Core Components

#### 1. **Client (`client/client.lua`)**
- Table proximity detection and interaction prompts
- Player action input handling
- Animation and prop management
- Native RDR2 poker UI integration
- Spectator mode
- Visual feedback and notifications

#### 2. **Server (`server/server.lua`)**
- Game state management and synchronization
- Turn-based gameplay with timers
- Betting logic (call, raise, fold, check, all-in)
- Pot calculation and side pot mechanics
- Hand evaluation and winner determination
- Money transactions and house rake
- Security validation and anti-cheat
- Admin commands and table management

#### 3. **Framework Adapter (`shared/framework.lua`)**
- Automatic framework detection
- Unified API across LXR-Core, RSG-Core, VORP
- Player data abstraction
- Money transaction handling
- Notification system
- Callback management

#### 4. **Configuration (`config.lua`)**
- Centralized settings for all aspects
- Framework configuration
- Game rules and limits
- Economy settings
- Security parameters
- Performance tuning
- Localization settings

## 🎮 Game Flow

### Player Journey

1. **Approach Table** → Player walks near poker table
2. **Join Prompt** → System shows interaction prompt
3. **Buy-In** → Player purchases chips with money
4. **Seat Assignment** → Server assigns available seat
5. **Wait for Hand** → Game starts when 2+ players ready
6. **Play Poker** → Turn-based Texas Hold'em gameplay
7. **Hand Resolution** → Winners determined and paid
8. **Continue/Leave** → Player stays for next hand or leaves

### Game State Machine

```
WAITING → PLAYING → SHOWDOWN → (back to WAITING)
   ↑                               │
   └───────────────────────────────┘
```

### Betting Phases

1. **Pre-flop** → 2 hole cards dealt, blinds posted
2. **Flop** → 3 community cards revealed
3. **Turn** → 1 additional community card
4. **River** → Final community card
5. **Showdown** → Hand evaluation and winner determination

## 🛡️ Security Model

### Server Authority

All critical operations are **server-authoritative**:
- ✅ Money validation before every transaction
- ✅ Distance checks before actions
- ✅ Turn validation (is it really player's turn?)
- ✅ Bet amount validation
- ✅ Rate limiting to prevent spam
- ✅ Suspicious activity logging

### Client Responsibilities

Clients are **never trusted** for:
- ❌ Money amounts
- ❌ Game state changes
- ❌ Hand evaluation
- ❌ Winner determination
- ❌ Pot calculations

## 🚀 Performance Features

- **Smart Caching** - Framework and player data cached
- **Distance Optimization** - Props only render when nearby
- **Efficient Threading** - Minimal tick usage
- **Statebag System** - Efficient state synchronization
- **Event Throttling** - Rate-limited client events
- **Cleanup on Exit** - Automatic resource cleanup

## 🌍 Multi-Framework Support

Supports **automatic detection** of:
1. **LXR-Core** (Primary) - wolves.land framework
2. **RSG-Core** (Primary) - Popular RedM framework
3. **VORP Core** (Supported) - Legacy framework support
4. **Standalone** (Fallback) - Works without framework

The framework adapter provides a **unified API** so the core logic works identically across all frameworks.

## 📊 Data Flow

### Join Table Sequence

```
Client              Server              Framework
  │                   │                     │
  │──Join Request────>│                     │
  │                   │──Validate Money────>│
  │                   │<──Money Amount──────│
  │                   │──Remove Money──────>│
  │                   │<──Success───────────│
  │<──Seat Assigned───│                     │
  │                   │                     │
```

### Player Action Sequence

```
Client              Server              
  │                   │                   
  │──Action (Raise)──>│                   
  │                   │──Validate Turn    
  │                   │──Validate Amount  
  │                   │──Update State     
  │<──State Update────│                   
  │                   │──Broadcast────────>All Clients
```

## 🎯 Design Principles

1. **Security First** - Never trust client, validate everything
2. **Performance** - Optimized for production servers
3. **Compatibility** - Multi-framework support built-in
4. **Maintainability** - Clean separation of concerns
5. **Extensibility** - Easy to add features and customize
6. **User Experience** - Smooth, responsive gameplay

## 📦 File Structure

```
lxr-gambling-poker/
├── fxmanifest.lua          # Resource manifest
├── config.lua              # All configuration settings
├── client/
│   ├── README.md
│   └── client.lua          # Client-side logic
├── server/
│   ├── README.md
│   └── server.lua          # Server-side logic
├── shared/
│   ├── README.md
│   ├── framework.lua       # Framework adapter
│   └── locale.lua          # Localization system
├── locales/
│   └── en.lua              # English translations
└── docs/
    ├── overview.md         # This file
    ├── installation.md     # Setup guide
    ├── configuration.md    # Config reference
    ├── frameworks.md       # Framework integration
    ├── events.md           # API reference
    ├── security.md         # Security guide
    ├── performance.md      # Optimization guide
    └── screenshots.md      # Visual showcase
```

## 🔄 State Management

The system uses **server-side state** with client synchronization:

```lua
PokerTables[tableId] = {
    players = {},        -- Player data by seat number
    spectators = {},     -- Spectator list
    gameState = '',      -- waiting/playing/showdown
    currentTurn = nil,   -- Current player's seat
    pot = 0,            -- Total pot amount
    currentBet = 0,     -- Current bet to match
    phase = '',         -- preflop/flop/turn/river
    communityCards = {}, -- Visible cards
    deck = {},          -- Remaining cards
    -- ... more state
}
```

State is synchronized to clients via events after every action.

## 🎨 Customization

Highly customizable via `config.lua`:
- **Tables** - Multiple locations, different stakes
- **Economy** - Money or items, buy-in ranges
- **Rules** - Timers, blinds, raise limits
- **Visuals** - Props, animations, UI
- **Security** - Validation levels, logging
- **Performance** - Update intervals, caching

## 📚 Next Steps

- [Installation Guide](installation.md) - Get started
- [Configuration Reference](configuration.md) - Customize settings
- [Framework Integration](frameworks.md) - Framework details
- [API Reference](events.md) - Events and callbacks
- [Security Guide](security.md) - Best practices
- [Performance Guide](performance.md) - Optimization tips

---

🐺 **wolves.land** - The Land of Wolves | Where History Lives!
