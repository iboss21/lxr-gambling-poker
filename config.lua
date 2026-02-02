--[[
════════════════════════════════════════════════════════════════════════════════════════════════

    ██╗     ██╗  ██╗██████╗        ██████╗  ██████╗ ██╗  ██╗███████╗██████╗     ██╗   ██╗██████╗     ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝██╔══██╗    ██║   ██║╚════██╗   ██╔═████╗
    ██║      ╚███╔╝ ██████╔╝       ██████╔╝██║   ██║█████╔╝ █████╗  ██████╔╝    ██║   ██║ █████╔╝   ██║██╔██║
    ██║      ██╔██╗ ██╔══██╗       ██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗    ╚██╗ ██╔╝██╔═══╝    ████╔╝██║
    ███████╗██╔╝ ██╗██║  ██║       ██║     ╚██████╔╝██║  ██╗███████╗██║  ██║     ╚████╔╝ ███████╗██╗╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝      ╚═══╝  ╚══════╝╚═╝ ╚═════╝ 

    🐺 LXR Poker V2.0 - Configuration

    Professional Texas Hold'em Poker System Configuration
    Complete settings for gameplay, economy, frameworks, security, and performance

════════════════════════════════════════════════════════════════════════════════════════════════

    📋 SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════════════════
    Server Name:      The Land of Wolves 🐺
    Community:        Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description:      ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:             Serious Hardcore Roleplay
    Access:           Discord & Whitelisted
    Website:          https://www.wolves.land
    Discord:          https://discord.gg/CrKcWdfd3A
    GitHub:           https://github.com/iBoss21
    Store:            https://theluxempire.tebex.io
    Server Listing:   https://servers.redm.net/servers/detail/8gj7eb
    Developer:        iBoss21 / The Lux Empire
    ═══════════════════════════════════════════════════════════════════════════════════════════

    📦 RESOURCE INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════════════════
    Resource Name:    lxr-gambling-poker
    Version:          2.0.0
    Performance:      Optimized (0.00ms idle, <0.05ms active)
    Framework:        LXR-Core, RSG-Core, VORP (Auto-Detect)
    Tags:             RedM, Georgian, Poker, Gambling, Economy, RPG
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

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- ⚠️  RESOURCE NAME PROTECTION (DO NOT MODIFY)
-- ════════════════════════════════════════════════════════════════════════════════════════════
local REQUIRED_RESOURCE_NAME = 'lxr-gambling-poker'
local CURRENT_RESOURCE_NAME = GetCurrentResourceName()

if CURRENT_RESOURCE_NAME ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[

    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║                                                                                ║
    ║                      ⚠️  RESOURCE NAME MISMATCH ERROR ⚠️                       ║
    ║                                                                                ║
    ╠════════════════════════════════════════════════════════════════════════════════╣
    ║                                                                                ║
    ║  This resource MUST be named exactly: %s                ║
    ║                                                                                ║
    ║  Current resource name: %s                                   ║
    ║                                                                                ║
    ║  👉 TO FIX: Rename your resource folder to the required name                  ║
    ║                                                                                ║
    ║  This protection ensures compatibility with dependencies and prevents         ║
    ║  conflicts with other resources.                                              ║
    ║                                                                                ║
    ╚════════════════════════════════════════════════════════════════════════════════╝

    ]], REQUIRED_RESOURCE_NAME, CURRENT_RESOURCE_NAME))
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- 📋 INITIALIZE CONFIG TABLE
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config = Config or {}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER INFORMATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.ServerInfo = {
    name          = 'The Land of Wolves 🐺',
    tagline       = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description   = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type          = 'Serious Hardcore Roleplay',
    access        = 'Discord & Whitelisted',
    website       = 'https://www.wolves.land',
    discord       = 'https://discord.gg/CrKcWdfd3A',
    github        = 'https://github.com/iBoss21',
    store         = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer     = 'iBoss21 / The Lux Empire',
    tags          = {'RedM','Georgian','SeriousRP','Whitelist','Economy','RPG','Poker','Gambling'}
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK CONFIGURATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
--[[
    Framework Priority (in order):
    1. LXR-Core       - Primary framework (wolves.land)
    2. RSG-Core       - Primary RedM framework
    3. VORP Core      - Legacy/Supported framework
    4. Standalone     - No framework fallback
    
    Set to 'auto' for automatic detection, or specify: 'lxr', 'rsg', 'vorp', 'standalone'
]]
Config.Framework = 'auto' -- 'auto', 'lxr', 'rsg', 'vorp', 'standalone'

-- Framework-Specific Settings
Config.FrameworkSettings = {
    -- LXR-Core Settings (Primary)
    ['lxr'] = {
        resourceName = 'lxr-core',
        callbackPrefix = 'lxr-core:callback:',
        clientPrefix = 'lxr-core:client:',
        serverPrefix = 'lxr-core:server:',
        -- LXR-Core specific exports
        getCoreObject = function()
            return exports['lxr-core']:GetCoreObject()
        end
    },
    
    -- RSG-Core Settings (Primary)
    ['rsg'] = {
        resourceName = 'rsg-core',
        callbackPrefix = 'RSGCore:Callback:',
        clientPrefix = 'RSGCore:Client:',
        serverPrefix = 'RSGCore:Server:',
        -- RSG-Core specific exports
        getCoreObject = function()
            return exports['rsg-core']:GetCoreObject()
        end
    },
    
    -- VORP Core Settings (Supported)
    ['vorp'] = {
        resourceName = 'vorp_core',
        callbackPrefix = 'vorp:callback:',
        clientPrefix = 'vorp:client:',
        serverPrefix = 'vorp:server:',
        -- VORP specific exports
        getCoreObject = function()
            return exports.vorp_core:GetCore()
        end
    },
    
    -- Standalone Settings (No Framework)
    ['standalone'] = {
        resourceName = nil,
        enabled = true
    }
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ LANGUAGE CONFIGURATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Lang = 'en' -- Available: 'en', 'ka' (Georgian), 'es', 'fr', etc.

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ GENERAL POKER SETTINGS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.General = {
    -- Resource Identification
    resourceName = 'lxr-gambling-poker',
    version = '2.0.0',
    
    -- Poker Game Type
    gameType = 'holdem', -- Texas Hold'em
    
    -- Use Native RDR2 Poker UI
    useNativeUI = true,
    
    -- Maximum Players per Table
    maxPlayers = 6,
    
    -- Allow Spectators
    allowSpectators = true,
    maxSpectators = 4,
    
    -- Enable NPC Dealers
    enableDealers = true,
    
    -- Enable NPC Players (AI)
    enableNPCPlayers = true,
    maxNPCPlayers = 5,
    
    -- Admin Reset Permission
    adminResetCommand = 'poker_reset',
    adminAcePermission = 'poker.admin',
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ POKER TABLE LOCATIONS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Tables = {
    -- Valentine Saloon
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
        -- Table Props
        props = {
            table = `p_tablecards01x`, -- Native poker table
            chairs = {
                {model = `p_chair05x`, coords = vector3(-308.38, 780.41, 118.48), heading = 0.0},
                {model = `p_chair05x`, coords = vector3(-307.08, 779.71, 118.48), heading = 60.0},
                {model = `p_chair05x`, coords = vector3(-307.08, 778.11, 118.48), heading = 120.0},
                {model = `p_chair05x`, coords = vector3(-308.38, 777.41, 118.48), heading = 180.0},
                {model = `p_chair05x`, coords = vector3(-309.68, 778.11, 118.48), heading = 240.0},
                {model = `p_chair05x`, coords = vector3(-309.68, 779.71, 118.48), heading = 300.0},
            },
            dealer = {
                model = `u_m_m_sdcardgambler_01`, -- Dealer NPC model
                coords = vector3(-308.38, 778.91, 118.48),
                heading = 90.0
            }
        },
        -- Buy-in Requirements
        minBuyIn = 50,    -- Minimum $50
        maxBuyIn = 1000,  -- Maximum $1000
        bigBlind = 10,    -- Big blind $10
        smallBlind = 5,   -- Small blind $5
        
        -- House Rake (dealer commission)
        houseRake = 0.05, -- 5% of pot goes to house
        houseRakeAccount = 'bank_saloon', -- Where rake goes (optional)
    },
    
    -- Saint Denis Saloon
    {
        id = 2,
        name = 'Saint Denis High Stakes',
        location = vector3(2630.47, -1223.11, 53.38),
        heading = 90.0,
        blip = {
            enabled = true,
            sprite = `blip_poker_table`,
            name = 'High Stakes Poker',
            scale = 0.2
        },
        props = {
            table = `p_tablecards01x`,
            chairs = {
                {model = `p_chair05x`, coords = vector3(2630.47, -1221.61, 53.38), heading = 0.0},
                {model = `p_chair05x`, coords = vector3(2631.77, -1222.31, 53.38), heading = 60.0},
                {model = `p_chair05x`, coords = vector3(2631.77, -1223.91, 53.38), heading = 120.0},
                {model = `p_chair05x`, coords = vector3(2630.47, -1224.61, 53.38), heading = 180.0},
                {model = `p_chair05x`, coords = vector3(2629.17, -1223.91, 53.38), heading = 240.0},
                {model = `p_chair05x`, coords = vector3(2629.17, -1222.31, 53.38), heading = 300.0},
            },
            dealer = {
                model = `u_m_m_sdcardgambler_01`,
                coords = vector3(2630.47, -1223.11, 53.38),
                heading = 270.0
            }
        },
        minBuyIn = 200,
        maxBuyIn = 5000,
        bigBlind = 50,
        smallBlind = 25,
        houseRake = 0.03, -- 3% for high stakes
        houseRakeAccount = 'bank_saloon',
    },
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ECONOMY SETTINGS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Economy = {
    -- Currency Type
    useMoney = true,           -- Use money (dollars)
    useItems = false,          -- Use items as chips (e.g., poker_chips)
    
    -- Money Settings
    moneyType = 'cash',        -- 'cash' or 'bank'
    moneyAccount = 'cash',     -- Account name for frameworks
    
    -- Item Settings (if useItems = true)
    chipItem = 'poker_chip',   -- Item name for poker chips
    chipValue = 1,             -- Each chip = $1
    
    -- Winnings Distribution
    payoutMethod = 'instant',  -- 'instant' or 'delayed'
    payoutDelay = 5,           -- Seconds (if delayed)
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ POKER GAME RULES █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.GameRules = {
    -- Betting Rules
    minRaise = 'bigBlind',     -- Minimum raise = big blind
    allowAllIn = true,         -- Allow all-in bets
    allowSidePots = true,      -- Enable side pot mechanics
    
    -- Turn Timer
    turnTimer = 60,            -- 60 seconds per turn
    warnAt = 15,               -- Warning at 15 seconds
    
    -- Round Settings
    dealerRotation = true,     -- Rotate dealer button each hand
    
    -- Hand Rankings (in order)
    handRankings = {
        'royal_flush',
        'straight_flush',
        'four_of_a_kind',
        'full_house',
        'flush',
        'straight',
        'three_of_a_kind',
        'two_pair',
        'one_pair',
        'high_card'
    },
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ANIMATIONS & PROPS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Animations = {
    -- Player Animations
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
    
    folding = {
        dict = 'script_re@poker@@seated@player@fold',
        anim = 'fold',
        flag = 48,
    },
    
    winning = {
        dict = 'script_re@poker@@seated@player@win',
        anim = 'win',
        flag = 48,
    },
    
    -- Dealer Animations
    dealing = {
        dict = 'script_re@poker@@seated@dealer@',
        anim = 'deal',
        flag = 48,
    },
}

-- Card Props
Config.Props = {
    chips = `p_chipsstack01x`,
    cards = `p_cards01x`,
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ INTERACTION KEYS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Keys = {
    -- Join/Leave Table
    interact = 0x760A9C6F,     -- [G] key
    
    -- Poker Actions
    call = 0xC7B5340A,         -- [ENTER] key
    raise = 0x07B8BEAF,        -- [R] key
    fold = 0x8FD015D8,         -- [F] key
    allIn = 0xD9D0E1C0,        -- [A] key
    check = 0x156F7119,        -- [SPACE] key
    
    -- UI Navigation
    up = 0x911CB09E,           -- [W] key
    down = 0x7065027D,         -- [S] key
    confirm = 0xC7B5340A,      -- [ENTER] key
    cancel = 0x156F7119,       -- [BACKSPACE] key
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ NOTIFICATION SETTINGS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Notifications = {
    -- Notification Type
    type = 'native',           -- 'native', 'framework', 'custom'
    
    -- Native Notification Settings
    native = {
        dict = 'ITEMTYPE_TEXTURES',
        texture = 'poker_chip',
        duration = 5000,       -- 5 seconds
        soundSet = 'HUD_Awards',
        soundName = 'CHECKPOINT_NORMAL',
    },
    
    -- Framework Notification (uses framework's notification system)
    framework = {
        position = 'top-right',
    },
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SECURITY & ANTI-CHEAT █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Security = {
    -- Server-Side Validation
    validateMoney = true,          -- Always validate player money server-side
    validateDistance = true,       -- Check player distance to table
    maxDistance = 5.0,             -- Maximum distance from table (meters)
    
    -- Anti-Cheat Measures
    detectSpeedHack = true,        -- Detect abnormal turn speeds
    detectMoneyHack = true,        -- Detect impossible money amounts
    logSuspiciousActivity = true,  -- Log suspicious actions
    
    -- Rate Limiting
    actionCooldown = 0.5,          -- 0.5 seconds between actions
    maxActionsPerMinute = 60,      -- Maximum actions per minute
    
    -- Ban Settings
    autoBan = false,               -- Auto-ban on cheat detection
    banDuration = 86400,           -- Ban duration (24 hours in seconds)
    
    -- Logging
    enableLogging = true,
    logToFile = false,             -- Log to file (requires file logger)
    logToDiscord = false,          -- Log to Discord webhook
    discordWebhook = '',           -- Discord webhook URL
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ PERFORMANCE OPTIMIZATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Performance = {
    -- Thread Update Intervals
    blipUpdateInterval = 5000,     -- Update blips every 5 seconds
    tableCheckInterval = 1000,     -- Check table proximity every 1 second
    stateUpdateInterval = 500,     -- Update game state every 0.5 seconds
    
    -- Caching
    cacheFramework = true,         -- Cache framework object
    cachePlayers = true,           -- Cache player data
    cacheTimeout = 60,             -- Cache timeout (seconds)
    
    -- Distance Optimization
    renderDistance = 50.0,         -- Render props within 50 meters
    interactDistance = 3.0,        -- Show prompts within 3 meters
    
    -- Resource Cleanup
    autoCleanup = true,            -- Auto-cleanup unused resources
    cleanupInterval = 300,         -- Cleanup every 5 minutes
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ DEBUG SETTINGS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Debug = {
    enabled = false,               -- Enable debug mode
    printToConsole = true,         -- Print debug messages to console
    printToChat = false,           -- Print debug messages to chat
    showCoords = false,            -- Show coordinates on screen
    showState = false,             -- Show game state on screen
    logEvents = false,             -- Log all events
    logCallbacks = false,          -- Log all callbacks
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ DATABASE CONFIGURATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Database = {
    enabled = true,                -- Enable database integration
    useOxMySQL = true,             -- Use oxmysql
    
    -- Table Names
    tables = {
        players = 'poker_players',       -- Player stats table
        games = 'poker_games',           -- Game history table
        hands = 'poker_hands',           -- Hand history table
    },
    
    -- Track Statistics
    trackStats = true,             -- Track player statistics
    trackHands = true,             -- Save hand history
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ DISCORD INTEGRATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
Config.Discord = {
    enabled = false,               -- Enable Discord logging
    webhook = '',                  -- Discord webhook URL
    
    -- Log Events
    logWins = true,                -- Log big wins
    logGames = true,               -- Log game start/end
    logHighStakes = true,          -- Log high stakes games
    highStakesThreshold = 1000,    -- Threshold for high stakes
    
    -- Embed Settings
    embedColor = 3447003,          -- Blue color
    embedAuthor = 'LXR Poker System',
    embedThumbnail = 'https://i.imgur.com/poker.png',
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ END OF CONFIGURATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Boot Message
if IsDuplicityVersion() then
    Citizen.CreateThread(function()
        print([[

    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║                                                                                ║
    ║     ██╗     ██╗  ██╗██████╗        ██████╗  ██████╗ ██╗  ██╗███████╗██████╗  ║
    ║     ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝██╔══██╗ ║
    ║     ██║      ╚███╔╝ ██████╔╝       ██████╔╝██║   ██║█████╔╝ █████╗  ██████╔╝ ║
    ║     ██║      ██╔██╗ ██╔══██╗       ██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗ ║
    ║     ███████╗██╔╝ ██╗██║  ██║       ██║     ╚██████╔╝██║  ██╗███████╗██║  ██║ ║
    ║     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ║
    ║                                                                                ║
    ╠════════════════════════════════════════════════════════════════════════════════╣
    ║                      🐺 LXR POKER V2.0 SYSTEM LOADED 🐺                        ║
    ╠════════════════════════════════════════════════════════════════════════════════╣
    ║  Version:        2.0.0                                                         ║
    ║  Framework:      ]] .. (Config.Framework == 'auto' and 'Auto-Detect' or string.upper(Config.Framework)) .. [[                                                     ║
    ║  Language:       ]] .. string.upper(Config.Lang) .. [[                                                            ║
    ║  Tables:         ]] .. #Config.Tables .. [[ configured                                                 ║
    ║  Security:       ]] .. (Config.Security.validateMoney and 'ENABLED' or 'DISABLED') .. [[                                                       ║
    ║  Performance:    OPTIMIZED                                                     ║
    ╠════════════════════════════════════════════════════════════════════════════════╣
    ║  Server:         ]] .. Config.ServerInfo.name .. [[                                      ║
    ║  Discord:        ]] .. Config.ServerInfo.discord .. [[            ║
    ║  Developer:      ]] .. Config.ServerInfo.developer .. [[                          ║
    ╠════════════════════════════════════════════════════════════════════════════════╣
    ║  🎯 Professional Texas Hold'em Poker for RedM                                  ║
    ║  ✓ Native RDR2 Integration | ✓ Multi-Framework | ✓ Anti-Cheat                 ║
    ╚════════════════════════════════════════════════════════════════════════════════╝

        ]])
    end)
end
