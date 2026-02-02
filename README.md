```
════════════════════════════════════════════════════════════════════════════════════════════════

    ██╗     ██╗  ██╗██████╗        ██████╗  ██████╗ ██╗  ██╗███████╗██████╗     ██╗   ██╗██████╗     ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝██╔══██╗    ██║   ██║╚════██╗   ██╔═████╗
    ██║      ╚███╔╝ ██████╔╝       ██████╔╝██║   ██║█████╔╝ █████╗  ██████╔╝    ██║   ██║ █████╔╝   ██║██╔██║
    ██║      ██╔██╗ ██╔══██╗       ██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗    ╚██╗ ██╔╝██╔═══╝    ████╔╝██║
    ███████╗██╔╝ ██╗██║  ██║       ██║     ╚██████╔╝██║  ██╗███████╗██║  ██║     ╚████╔╝ ███████╗██╗╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝      ╚═══╝  ╚══════╝╚═╝ ╚═════╝ 

    🐺 LXR Poker V2.0 - Professional Texas Hold'em for RedM
    
════════════════════════════════════════════════════════════════════════════════════════════════
```

# 🃏 LXR Gambling Poker V2.0

**Professional Texas Hold'em Poker System for RedM**  
*Complete with native RDR2 integration, animations, and multi-framework support*

[![RedM](https://img.shields.io/badge/RedM-Compatible-red.svg)](https://redm.net/)
[![Framework](https://img.shields.io/badge/Framework-Multi--Framework-blue.svg)](#framework-support)
[![Version](https://img.shields.io/badge/Version-2.0.0-green.svg)](https://github.com/iboss21/lxr-gambling-poker)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 Overview

LXR Poker V2.0 is a **professional-grade Texas Hold'em poker system** designed specifically for RedM servers. Built with the **Land of Wolves philosophy** of excellence, this resource provides a complete, realistic poker experience with native RDR2 integration, sophisticated game mechanics, and bulletproof security.

### 🌟 Key Features

✅ **Native RDR2 Poker Integration** - Authentic Wild West gambling experience  
✅ **Multi-Framework Support** - LXR-Core, RSG-Core, VORP Core, and Standalone  
✅ **Complete Game Rules** - Call, Raise, All-in, Fold, Check, Side Pots  
✅ **NPC Dealers & Players** - AI-powered poker opponents  
✅ **Synchronized Turn Management** - Server-authoritative game state  
✅ **Animations & Props** - Full player and dealer animations  
✅ **House Rake System** - Configurable dealer commission  
✅ **Admin Controls** - Table reset and management commands  
✅ **Security First** - Server-side validation, anti-cheat, rate limiting  
✅ **Performance Optimized** - 0.00ms idle, <0.05ms active  
✅ **Full Translations** - Multi-language support system  
✅ **Spectator Mode** - Watch games in progress  

---

## 🐺 Server Information

**Server Name:** The Land of Wolves 🐺  
**Community:** Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!  
**Type:** Serious Hardcore Roleplay  
**Website:** [wolves.land](https://www.wolves.land)  
**Discord:** [Join Our Community](https://discord.gg/CrKcWdfd3A)  
**Store:** [The Lux Empire Store](https://theluxempire.tebex.io)  
**Developer:** iBoss21 / The Lux Empire  

---

## 📦 Installation

### Quick Start

1. **Download** the resource and extract to your resources folder
2. **Rename** the folder to exactly `lxr-gambling-poker`
3. **Configure** `config.lua` to your preferences
4. **Add** to your `server.cfg`:
   ```cfg
   ensure lxr-gambling-poker
   ```
5. **Restart** your server

### Detailed Installation

See [docs/installation.md](docs/installation.md) for complete installation instructions, including database setup and framework-specific configuration.

---

## 🎮 Framework Support

This resource **automatically detects** and adapts to your framework:

### Primary Frameworks (Best Supported)
- **LXR-Core** - Primary framework for wolves.land
- **RSG-Core** - Primary RedM framework

### Supported Frameworks
- **VORP Core** - Legacy/supported framework

### Fallback
- **Standalone** - Works without any framework

The resource uses an intelligent **Framework Adapter Layer** that provides a unified API across all frameworks. See [docs/frameworks.md](docs/frameworks.md) for technical details.

---

## ⚙️ Configuration

The resource is highly configurable through `config.lua`:

- **🎲 Game Rules** - Blinds, timers, betting limits
- **💰 Economy** - Money types, buy-ins, house rake
- **🎨 Customization** - Tables, chairs, chips, cards
- **🔒 Security** - Anti-cheat, validation, rate limiting
- **📊 Performance** - Optimization settings
- **🌍 Localization** - Multi-language support
- **📍 Table Locations** - Multiple poker tables

See [docs/configuration.md](docs/configuration.md) for complete configuration guide.

---

## 🎯 Usage

### For Players

1. **Approach** a poker table (look for blips on map)
2. **Press G** to join the table
3. **Buy-in** with the required amount
4. **Play poker** using the action keys:
   - **ENTER** - Call
   - **R** - Raise
   - **F** - Fold
   - **SPACE** - Check
   - **A** - All In
5. **Leave** anytime by pressing G near the table

### For Admins

Reset a table:
```
/poker_reset <tableId>
```

Requires ACE permission: `poker.admin`

---

## 🛡️ Security Features

- ✅ **Server-Side Validation** - All actions validated server-side
- ✅ **Distance Checks** - Players must be near table
- ✅ **Money Validation** - Impossible to cheat money
- ✅ **Rate Limiting** - Prevents action spam
- ✅ **Anti-Speed Hack** - Detects abnormal turn speeds
- ✅ **Suspicious Activity Logging** - Track potential exploits
- ✅ **No Client Trust** - Never trust client-provided data

See [docs/security.md](docs/security.md) for security best practices.

---

## 🚀 Performance

**Optimized for Production Servers**

- **Idle:** 0.00ms (when no players nearby)
- **Active:** <0.05ms per table
- **Smart Caching:** Framework and player data
- **Distance Optimization:** Props only render when needed
- **Efficient Threads:** Minimal tick usage

See [docs/performance.md](docs/performance.md) for optimization tips.

---

## 📚 Documentation

Complete documentation available in the `/docs` folder:

- [📖 Overview](docs/overview.md) - System architecture and features
- [💿 Installation](docs/installation.md) - Step-by-step setup guide
- [⚙️ Configuration](docs/configuration.md) - All config options explained
- [🔄 Frameworks](docs/frameworks.md) - Multi-framework integration
- [📡 Events](docs/events.md) - API and event reference
- [🛡️ Security](docs/security.md) - Security features and best practices
- [⚡ Performance](docs/performance.md) - Optimization guide
- [📸 Screenshots](docs/screenshots.md) - Visual showcase

---

## 🎨 Screenshots

*Screenshots coming soon!*

Place your screenshots in `docs/assets/screenshots/` and they'll appear here.

---

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) file for details.

**Attribution Required:** If you use or modify this resource, you must credit:
- **iBoss21 / The Lux Empire**
- **wolves.land - The Land of Wolves**

---

## 👨‍💻 Credits

**Created by:** iBoss21 (The Lux Empire)  
**For:** wolves.land - The Land of Wolves 🐺  
**GitHub:** [@iBoss21](https://github.com/iBoss21)  
**Discord:** [Join Our Community](https://discord.gg/CrKcWdfd3A)  

---

## 💬 Support

**Need Help?**

- 📖 Check the [documentation](docs/)
- 💬 Join our [Discord](https://discord.gg/CrKcWdfd3A)
- 🐛 Report bugs via [GitHub Issues](https://github.com/iboss21/lxr-gambling-poker/issues)
- 🛍️ Premium support available at [The Lux Empire Store](https://theluxempire.tebex.io)

---

```
═══════════════════════════════════════════════════════════════════════════════════════════════
🐺 wolves.land - Where History Lives | ისტორია ცოცხლდება აქ!
═══════════════════════════════════════════════════════════════════════════════════════════════
```
