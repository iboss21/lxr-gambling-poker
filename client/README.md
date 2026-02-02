```
════════════════════════════════════════════════════════════════════════════════════════════════
    🐺 LXR Poker V2.0 - Client Scripts
════════════════════════════════════════════════════════════════════════════════════════════════
```

# Client Scripts

This folder contains all **client-side scripts** for the LXR Poker V2.0 system.

## 📁 Contents

- **client.lua** - Main client script handling:
  - Table proximity detection
  - Join/leave interactions
  - Poker action inputs
  - Animations and props
  - Native UI integration
  - Spectator mode
  - Turn timer display

## 🎯 Responsibilities

The client scripts are responsible for:

✅ **Player Experience** - UI, interactions, visual feedback  
✅ **Animations** - Sitting, betting, folding, winning  
✅ **Props Management** - Spawning tables, chairs, dealers  
✅ **Input Handling** - Poker actions (call, raise, fold, etc.)  
✅ **Blip Management** - Map markers for poker tables  
✅ **Notifications** - Player feedback and messages  
✅ **Performance** - Optimized proximity checks  

## 🔒 Security Note

Client scripts **never** handle sensitive operations like:
- Money transactions
- Game state validation
- Winner determination
- Economy changes

All critical operations are **server-authoritative** for maximum security.

---

🐺 **wolves.land** - The Land of Wolves
