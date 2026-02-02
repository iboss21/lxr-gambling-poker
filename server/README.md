```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Server Scripts
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Server Scripts

This folder contains all **server-side scripts** for the LXR Poker V2.0 system.

## 📁 Contents

- **server.lua** - Main server script handling:
  - Game state management
  - Turn management and timers
  - Betting logic validation
  - Pot calculation and distribution
  - Hand evaluation
  - Money transactions
  - House rake collection
  - Security validation
  - Admin commands
  - Database operations

## 🎯 Responsibilities

The server scripts are responsible for:

✅ **Game Logic** - All poker rules and mechanics  
✅ **State Management** - Game phases, turns, bets  
✅ **Security** - Validation, anti-cheat, rate limiting  
✅ **Economy** - Money handling, buy-ins, payouts  
✅ **Synchronization** - State updates to all clients  
✅ **Admin Controls** - Table management commands  
✅ **Database** - Statistics and hand history  

## 🛡️ Security First

All critical operations are **server-authoritative**:
- Money validation
- Distance checks
- Action validation
- Rate limiting
- Cheat detection

**Never trust the client!**

---

🐺 **wolves.land** - The Land of Wolves
