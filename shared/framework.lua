--[[
════════════════════════════════════════════════════════════════════════════════════════════════
    
    🐺 LXR Poker V2.0 - Framework Adapter Layer
    
    Multi-Framework Bridge providing unified API across:
    - LXR-Core (Primary)
    - RSG-Core (Primary)
    - VORP Core (Supported)
    - Standalone (Fallback)
    
════════════════════════════════════════════════════════════════════════════════════════════════
]]

Framework = {}
Framework.Core = nil
Framework.Type = nil
Framework.PlayerData = {}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK DETECTION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
function Framework.Detect()
    if Config.Framework ~= 'auto' then
        Framework.Type = Config.Framework
        if Config.Debug.enabled then
            print('[LXR Poker] Framework manually set to: ' .. Framework.Type)
        end
        return Framework.Type
    end
    
    -- Try LXR-Core first (Priority 1)
    if GetResourceState('lxr-core') == 'started' then
        Framework.Type = 'lxr'
        if Config.Debug.enabled then
            print('[LXR Poker] LXR-Core detected!')
        end
        return 'lxr'
    end
    
    -- Try RSG-Core (Priority 2)
    if GetResourceState('rsg-core') == 'started' then
        Framework.Type = 'rsg'
        if Config.Debug.enabled then
            print('[LXR Poker] RSG-Core detected!')
        end
        return 'rsg'
    end
    
    -- Try VORP Core (Priority 3)
    if GetResourceState('vorp_core') == 'started' then
        Framework.Type = 'vorp'
        if Config.Debug.enabled then
            print('[LXR Poker] VORP Core detected!')
        end
        return 'vorp'
    end
    
    -- Fallback to standalone
    Framework.Type = 'standalone'
    if Config.Debug.enabled then
        print('[LXR Poker] No framework detected, running in standalone mode')
    end
    return 'standalone'
end

-- Initialize framework detection
Framework.Detect()

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ GET CORE OBJECT █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
function Framework.GetCoreObject()
    if Framework.Core then
        return Framework.Core
    end
    
    if Framework.Type == 'lxr' then
        Framework.Core = exports['lxr-core']:GetCoreObject()
    elseif Framework.Type == 'rsg' then
        Framework.Core = exports['rsg-core']:GetCoreObject()
    elseif Framework.Type == 'vorp' then
        Framework.Core = exports.vorp_core:GetCore()
    end
    
    return Framework.Core
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ UNIFIED PLAYER FUNCTIONS █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Get Player Data
    @param source (server) or nil (client)
    @return PlayerData table
]]
function Framework.GetPlayerData(source)
    if IsDuplicityVersion() then
        -- Server-side
        if Framework.Type == 'lxr' then
            local Core = Framework.GetCoreObject()
            local Player = Core.Functions.GetPlayer(source)
            return Player and Player.PlayerData or nil
        elseif Framework.Type == 'rsg' then
            local Core = Framework.GetCoreObject()
            local Player = Core.Functions.GetPlayer(source)
            return Player and Player.PlayerData or nil
        elseif Framework.Type == 'vorp' then
            local Core = Framework.GetCoreObject()
            local User = Core.getUser(source)
            if User then
                local Character = User.getUsedCharacter
                return {
                    citizenid = Character.charIdentifier,
                    money = {cash = Character.money, bank = Character.bank},
                    job = {name = Character.job, grade = Character.jobGrade},
                    firstname = Character.firstname,
                    lastname = Character.lastname,
                }
            end
        elseif Framework.Type == 'standalone' then
            -- Standalone fallback
            return {
                source = source,
                citizenid = tostring(source),
                money = {cash = 1000, bank = 5000},
                job = {name = 'unemployed', grade = 0},
            }
        end
    else
        -- Client-side
        if Framework.Type == 'lxr' then
            local Core = Framework.GetCoreObject()
            return Core.Functions.GetPlayerData()
        elseif Framework.Type == 'rsg' then
            local Core = Framework.GetCoreObject()
            return Core.Functions.GetPlayerData()
        elseif Framework.Type == 'vorp' then
            return Framework.PlayerData
        elseif Framework.Type == 'standalone' then
            return {
                citizenid = GetPlayerServerId(PlayerId()),
                money = {cash = 1000, bank = 5000},
            }
        end
    end
    
    return nil
end

--[[
    Get Player Money
    @param source (server) or nil (client)
    @param moneyType 'cash' or 'bank'
    @return amount
]]
function Framework.GetMoney(source, moneyType)
    moneyType = moneyType or 'cash'
    
    if IsDuplicityVersion() then
        -- Server-side
        if Framework.Type == 'lxr' or Framework.Type == 'rsg' then
            local Core = Framework.GetCoreObject()
            local Player = Core.Functions.GetPlayer(source)
            if Player then
                if moneyType == 'cash' then
                    return Player.PlayerData.money.cash or 0
                else
                    return Player.PlayerData.money.bank or 0
                end
            end
        elseif Framework.Type == 'vorp' then
            local Core = Framework.GetCoreObject()
            local User = Core.getUser(source)
            if User then
                local Character = User.getUsedCharacter
                if moneyType == 'cash' then
                    return Character.money or 0
                else
                    return Character.bank or 0
                end
            end
        elseif Framework.Type == 'standalone' then
            return 1000 -- Default amount
        end
    else
        -- Client-side
        local PlayerData = Framework.GetPlayerData()
        if PlayerData and PlayerData.money then
            return PlayerData.money[moneyType] or 0
        end
    end
    
    return 0
end

--[[
    Add Money to Player
    @param source number
    @param amount number
    @param moneyType 'cash' or 'bank'
    @return success boolean
]]
function Framework.AddMoney(source, amount, moneyType)
    if not IsDuplicityVersion() then return false end
    
    moneyType = moneyType or 'cash'
    
    if Framework.Type == 'lxr' or Framework.Type == 'rsg' then
        local Core = Framework.GetCoreObject()
        local Player = Core.Functions.GetPlayer(source)
        if Player then
            Player.Functions.AddMoney(moneyType, amount)
            return true
        end
    elseif Framework.Type == 'vorp' then
        local Core = Framework.GetCoreObject()
        local User = Core.getUser(source)
        if User then
            local Character = User.getUsedCharacter
            if moneyType == 'cash' then
                Character.addCurrency(0, amount)
            else
                Character.addCurrency(1, amount)
            end
            return true
        end
    elseif Framework.Type == 'standalone' then
        return true -- Simulate success
    end
    
    return false
end

--[[
    Remove Money from Player
    @param source number
    @param amount number
    @param moneyType 'cash' or 'bank'
    @return success boolean
]]
function Framework.RemoveMoney(source, amount, moneyType)
    if not IsDuplicityVersion() then return false end
    
    moneyType = moneyType or 'cash'
    
    if Framework.Type == 'lxr' or Framework.Type == 'rsg' then
        local Core = Framework.GetCoreObject()
        local Player = Core.Functions.GetPlayer(source)
        if Player then
            Player.Functions.RemoveMoney(moneyType, amount)
            return true
        end
    elseif Framework.Type == 'vorp' then
        local Core = Framework.GetCoreObject()
        local User = Core.getUser(source)
        if User then
            local Character = User.getUsedCharacter
            if moneyType == 'cash' then
                Character.removeCurrency(0, amount)
            else
                Character.removeCurrency(1, amount)
            end
            return true
        end
    elseif Framework.Type == 'standalone' then
        return true -- Simulate success
    end
    
    return false
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ UNIFIED NOTIFICATION SYSTEM █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Show Notification
    @param source number (server-side) or nil (client-side)
    @param message string
    @param type 'success', 'error', 'info', 'warning'
    @param duration number (milliseconds)
]]
function Framework.Notify(source, message, type, duration)
    type = type or 'info'
    duration = duration or 5000
    
    if IsDuplicityVersion() then
        -- Server-side notification (trigger client)
        if Config.Notifications.type == 'native' then
            TriggerClientEvent('lxr-poker:client:notify', source, message, type, duration)
        else
            if Framework.Type == 'lxr' then
                TriggerClientEvent('lxr-core:client:notify', source, message, type, duration)
            elseif Framework.Type == 'rsg' then
                TriggerClientEvent('RSGCore:Notify', source, message, type, duration)
            elseif Framework.Type == 'vorp' then
                local Core = Framework.GetCoreObject()
                Core.NotifyRightTip(source, message, duration)
            else
                TriggerClientEvent('lxr-poker:client:notify', source, message, type, duration)
            end
        end
    else
        -- Client-side notification
        if Config.Notifications.type == 'native' then
            -- Native RDR2 notification
            local dict = Config.Notifications.native.dict
            local texture = Config.Notifications.native.texture
            
            Citizen.InvokeNative(0xFA233F8FE190514C, dict) -- Load texture dict
            while not Citizen.InvokeNative(0x5E0CF89C97C0C76F, dict) do -- Has loaded
                Wait(10)
            end
            
            Citizen.InvokeNative(0xD05590C1AB38F068, 1, message, dict, texture, GetHashKey('COLOR_PURE_WHITE'), duration)
        else
            if Framework.Type == 'lxr' then
                local Core = Framework.GetCoreObject()
                Core.Functions.Notify(message, type, duration)
            elseif Framework.Type == 'rsg' then
                local Core = Framework.GetCoreObject()
                Core.Functions.Notify(message, type, duration)
            elseif Framework.Type == 'vorp' then
                local Core = Framework.GetCoreObject()
                Core.NotifyRightTip(message, duration)
            else
                -- Fallback to simple print
                print('[LXR Poker] ' .. message)
            end
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ UNIFIED CALLBACK SYSTEM █████
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Register Server Callback
    @param name string
    @param callback function
]]
function Framework.CreateCallback(name, callback)
    if not IsDuplicityVersion() then return end
    
    if Framework.Type == 'lxr' then
        local Core = Framework.GetCoreObject()
        Core.Functions.CreateCallback(name, callback)
    elseif Framework.Type == 'rsg' then
        local Core = Framework.GetCoreObject()
        Core.Functions.CreateCallback(name, callback)
    elseif Framework.Type == 'vorp' then
        local Core = Framework.GetCoreObject()
        Core.addRpc(name, callback)
    else
        -- Standalone callback system
        RegisterServerEvent('lxr-poker:server:callback:' .. name)
        AddEventHandler('lxr-poker:server:callback:' .. name, function(...)
            local source = source
            local args = {...}
            local cb = table.remove(args)
            callback(source, function(...)
                cb(...)
            end, table.unpack(args))
        end)
    end
end

--[[
    Trigger Server Callback (Client)
    @param name string
    @param callback function
    @param ... arguments
]]
function Framework.TriggerCallback(name, callback, ...)
    if IsDuplicityVersion() then return end
    
    if Framework.Type == 'lxr' then
        local Core = Framework.GetCoreObject()
        Core.Functions.TriggerCallback(name, callback, ...)
    elseif Framework.Type == 'rsg' then
        local Core = Framework.GetCoreObject()
        Core.Functions.TriggerCallback(name, callback, ...)
    elseif Framework.Type == 'vorp' then
        local Core = Framework.GetCoreObject()
        Core.callRpc(name, callback, ...)
    else
        -- Standalone callback system
        local args = {...}
        TriggerServerEvent('lxr-poker:server:callback:' .. name, function(...)
            callback(...)
        end, table.unpack(args))
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CLIENT-SIDE INITIALIZATION █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
if not IsDuplicityVersion() then
    -- VORP specific: Wait for character selection
    if Framework.Type == 'vorp' then
        RegisterNetEvent('vorp:SelectedCharacter')
        AddEventHandler('vorp:SelectedCharacter', function(charid)
            local Core = Framework.GetCoreObject()
            Core.RpcCall('vorp:getCharacter', function(character)
                Framework.PlayerData = {
                    citizenid = character.charIdentifier,
                    money = {cash = character.money, bank = character.bank},
                    job = {name = character.job, grade = character.jobGrade},
                    firstname = character.firstname,
                    lastname = character.lastname,
                }
            end, charid)
        end)
    end
    
    -- Register client-side notify event
    RegisterNetEvent('lxr-poker:client:notify')
    AddEventHandler('lxr-poker:client:notify', function(message, type, duration)
        Framework.Notify(nil, message, type, duration)
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ADMIN PERMISSION CHECK █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
function Framework.HasPermission(source, permission)
    if not IsDuplicityVersion() then return false end
    
    -- Check ACE permissions first
    if IsPlayerAceAllowed(source, permission) then
        return true
    end
    
    -- Framework-specific admin checks
    if Framework.Type == 'lxr' or Framework.Type == 'rsg' then
        local Core = Framework.GetCoreObject()
        local Player = Core.Functions.GetPlayer(source)
        if Player then
            local group = Player.PlayerData.group or 'user'
            return group == 'admin' or group == 'god'
        end
    elseif Framework.Type == 'vorp' then
        local Core = Framework.GetCoreObject()
        local User = Core.getUser(source)
        if User then
            return User.getGroup == 'admin' or User.getGroup == 'superadmin'
        end
    end
    
    return false
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK ADAPTER INITIALIZED █████
-- ════════════════════════════════════════════════════════════════════════════════════════════
if Config.Debug.enabled then
    print('[LXR Poker] Framework Adapter initialized with: ' .. Framework.Type)
end
