--[[
════════════════════════════════════════════════════════════════════════════════════════════════
    
    ██╗     ██╗  ██╗██████╗        ██████╗  ██████╗ ██╗  ██╗███████╗██████╗     ██╗   ██╗██████╗     ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝██╔══██╗    ██║   ██║╚════██╗   ██╔═████╗
    ██║      ╚███╔╝ ██████╔╝       ██████╔╝██║   ██║█████╔╝ █████╗  ██████╔╝    ██║   ██║ █████╔╝   ██║██╔██║
    ██║      ██╔██╗ ██╔══██╗       ██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗    ╚██╗ ██╔╝██╔═══╝    ████╔╝██║
    ███████╗██╔╝ ██╗██║  ██║       ██║     ╚██████╔╝██║  ██╗███████╗██║  ██║     ╚████╔╝ ███████╗██╗╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝      ╚═══╝  ╚══════╝╚═╝ ╚═════╝ 
    
    🐺 LXR Poker V2.0 - FiveM/RedM Resource Manifest
    
    Professional Texas Hold'em Poker System for RedM
    Complete with native RDR2 integration, animations, and multi-framework support
    
════════════════════════════════════════════════════════════════════════════════════════════════
    
    📋 SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════════════════
    Server Name:      The Land of Wolves 🐺
    Community:        Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Type:             Serious Hardcore Roleplay
    Website:          https://www.wolves.land
    Discord:          https://discord.gg/CrKcWdfd3A
    Store:            https://theluxempire.tebex.io
    Developer:        iBoss21 / The Lux Empire
    ═══════════════════════════════════════════════════════════════════════════════════════════
    
    📦 RESOURCE METADATA
    ═══════════════════════════════════════════════════════════════════════════════════════════
    Resource Name:    lxr-gambling-poker
    Version:          2.0.0
    Game:             RedM
    Framework:        LXR-Core, RSG-Core, VORP (Auto-Detect)
    Performance:      Optimized (0.00ms idle, <0.05ms active)
    Dependencies:     Framework (auto-detected), RedM natives
    ═══════════════════════════════════════════════════════════════════════════════════════════
    
    ✨ FEATURES
    ═══════════════════════════════════════════════════════════════════════════════════════════
    ✓ Native RDR2 Texas Hold'em Poker Integration
    ✓ Multi-Framework Support (LXR-Core, RSG-Core, VORP)
    ✓ Configurable Tables, Chairs, Chips, and Card Sets
    ✓ NPC Dealer & Player Support
    ✓ Full Poker Rules (Call, Raise, All-in, Fold, Side Pots)
    ✓ Statebag Synchronization System
    ✓ Admin Table Reset Controls
    ✓ Synchronized Turn Management
    ✓ Animations & Props Synchronization
    ✓ Native UI Integration
    ✓ House Rake System
    ✓ Anti-Cheat & Server-Side Validation
    ✓ Full Translations Support
    ✓ Performance Optimized
    ═══════════════════════════════════════════════════════════════════════════════════════════
    
    👨‍💻 CREDITS & COPYRIGHT
    ═══════════════════════════════════════════════════════════════════════════════════════════
    Created by:       iBoss21 (The Lux Empire)
    For:              wolves.land - The Land of Wolves
    GitHub:           https://github.com/iBoss21
    License:          MIT License with Attribution Required
    Copyright:        © 2026 iBoss21 / The Lux Empire
    ═══════════════════════════════════════════════════════════════════════════════════════════
    
════════════════════════════════════════════════════════════════════════════════════════════════
]]

-- RedM Prerelease Warning (MANDATORY)
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'

-- FXManifest Metadata
fx_version 'cerulean'
game 'rdr3'
lua54 'yes'

-- Resource Metadata
name 'lxr-gambling-poker'
author 'iBoss21 / The Lux Empire'
description 'Professional Texas Hold\'em Poker System for RedM - Complete with native RDR2 integration, NPC support, and multi-framework compatibility'
version '2.0.0'

-- Framework Dependencies (Optional - Runtime Detection Used)
-- These are optional as the script will auto-detect available frameworks
-- Uncomment if you want to ensure framework is loaded first
-- dependencies {
--     '/server:5848',    -- Minimum RedM server version
--     '/gameBuild:1355', -- Minimum game build
--     -- 'lxr-core',     -- LXR-Core Framework (Optional)
--     -- 'rsg-core',     -- RSG-Core Framework (Optional)
--     -- 'vorp_core',    -- VORP Core Framework (Optional)
-- }

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- 🎯 SHARED SCRIPTS (Config & Framework Bridge)
-- ═══════════════════════════════════════════════════════════════════════════════════════════
shared_scripts {
    'config.lua',              -- Main configuration file
    'shared/framework.lua',    -- Framework adapter/bridge layer
    'shared/locale.lua',       -- Localization system
    'locales/en.lua',          -- English language file
    -- Add more language files here as needed:
    -- 'locales/ka.lua',       -- Georgian language file
    -- 'locales/es.lua',       -- Spanish language file
    -- 'locales/fr.lua',       -- French language file
}

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- 💻 CLIENT SCRIPTS (UI, Interactions, Animations)
-- ═══════════════════════════════════════════════════════════════════════════════════════════
client_scripts {
    'client/client.lua',       -- Main client logic
}

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- 🖥️  SERVER SCRIPTS (Game Logic, Security, Economy)
-- ═══════════════════════════════════════════════════════════════════════════════════════════
server_scripts {
    '@oxmysql/lib/MySQL.lua',  -- MySQL/oxmysql support (optional)
    'server/server.lua',       -- Main server logic
}

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- 📁 FILE SCOPE EXPLANATION
-- ═══════════════════════════════════════════════════════════════════════════════════════════
--[[
    SHARED SCRIPTS:
    - config.lua          : All configuration settings, framework settings, poker rules
    - shared/framework.lua: Multi-framework adapter providing unified API across frameworks
    - shared/locale.lua   : Translation/localization system for multi-language support
    - locales/*.lua       : Language files for different languages
    
    CLIENT SCRIPTS:
    - client/client.lua   : Player interactions, poker UI, animations, props, spectator mode
    
    SERVER SCRIPTS:
    - server/server.lua   : Game state management, turn management, security validation,
                            economy handling, house rake, admin controls, database operations
    
    ARCHITECTURE:
    This resource uses a clean separation of concerns:
    1. Config layer (config.lua) - All settings in one place
    2. Framework layer (shared/framework.lua) - Unified API across frameworks
    3. Client layer (client/*) - Player experience and UI
    4. Server layer (server/*) - Game logic and security
    5. Locale layer (shared/locale.lua + locales/*) - Translations
    
    FRAMEWORK SUPPORT:
    The script automatically detects and adapts to:
    - LXR-Core (Primary)
    - RSG-Core (Primary)
    - VORP Core (Supported)
    - Standalone fallback
]]

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- 🎮 END OF MANIFEST
-- ═══════════════════════════════════════════════════════════════════════════════════════════
