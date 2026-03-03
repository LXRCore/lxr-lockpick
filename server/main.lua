--[[
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗  ██████╗██╗  ██╗██████╗ ██╗ ██████╗██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗       ██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔══██╗██║██╔════╝██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝ ─────  ██║     ██║   ██║██║     █████╔╝ ██████╔╝██║██║     █████╔╝
    ██║      ██╔██╗ ██╔══██╗       ██║     ██║   ██║██║     ██╔═██╗ ██╔═══╝ ██║██║     ██╔═██╗
    ███████╗██╔╝ ██╗██║  ██║       ███████╗╚██████╔╝╚██████╗██║  ██╗██║     ██║╚██████╗██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝

    🐺 LXR Lockpick — Server-Side Handler
    Framework-aware item checks and lockpick consumption.

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    Server:    The Land of Wolves 🐺
    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    Store:     https://theluxempire.tebex.io
    ═══════════════════════════════════════════════════════════════════════════════
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK BRIDGE — SERVER SIDE
-- ═══════════════════════════════════════════════════════════════════════════════

local Framework = nil
local frameworkName = nil

local function InitFramework()
    if Config.Framework ~= 'auto' then
        frameworkName = Config.Framework
    elseif GetResourceState('lxr-core') == 'started' then
        frameworkName = 'lxr-core'
    elseif GetResourceState('rsg-core') == 'started' then
        frameworkName = 'rsg-core'
    elseif GetResourceState('vorp_core') == 'started' then
        frameworkName = 'vorp_core'
    elseif GetResourceState('redem_roleplay') == 'started' then
        frameworkName = 'redem_roleplay'
    elseif GetResourceState('qbr-core') == 'started' then
        frameworkName = 'qbr-core'
    elseif GetResourceState('qr-core') == 'started' then
        frameworkName = 'qr-core'
    else
        frameworkName = 'standalone'
    end

    if frameworkName == 'lxr-core' then
        Framework = exports['lxr-core']:GetCoreObject()
    elseif frameworkName == 'rsg-core' then
        Framework = exports['rsg-core']:GetCoreObject()
    elseif frameworkName == 'vorp_core' then
        Framework = exports['vorp_core']:GetCoreObject()
    elseif frameworkName == 'qbr-core' then
        Framework = exports['qbr-core']:GetCoreObject()
    elseif frameworkName == 'qr-core' then
        Framework = exports['qr-core']:GetCoreObject()
    end

    print(string.format(
        '^2[lxr-lockpick]^7 🐺 wolves.land | Framework detected: ^3%s^7',
        frameworkName
    ))
end

-- ── Inventory helpers ─────────────────────────────────────────────────────────

local function PlayerHasItem(source, itemName)
    if not Config.Lockpick.item then return true end

    if frameworkName == 'lxr-core' or frameworkName == 'rsg-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if not Player then return false end
        local item = Player.Functions.GetItemByName(itemName)
        return item ~= nil and item.amount > 0

    elseif frameworkName == 'vorp_core' then
        local character = Framework.GetCharacter(source)
        if not character then return false end
        return character.getItem(itemName) ~= nil

    elseif frameworkName == 'qbr-core' or frameworkName == 'qr-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if not Player then return false end
        local item = Player.Functions.GetItemByName(itemName)
        return item ~= nil and item.amount > 0

    else
        -- standalone / redem — no inventory check, always allow
        return true
    end
end

local function RemoveItemFromPlayer(source, itemName, amount)
    if not Config.Lockpick.item then return end
    amount = amount or 1

    if frameworkName == 'lxr-core' or frameworkName == 'rsg-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if Player then
            Player.Functions.RemoveItem(itemName, amount)
        end

    elseif frameworkName == 'vorp_core' then
        local character = Framework.GetCharacter(source)
        if character then
            character.removeItem(itemName, amount)
        end

    elseif frameworkName == 'qbr-core' or frameworkName == 'qr-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if Player then
            Player.Functions.RemoveItem(itemName, amount)
        end
    end
    -- standalone / redem — no-op
end

-- ── Boot ──────────────────────────────────────────────────────────────────────

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        InitFramework()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Called by client before opening the lockpick UI.
-- Validates item ownership and fires the open event back to the requesting
-- client only if the check passes.
RegisterNetEvent('lxr-lockpick:server:openLockpick', function()
    local src = source
    local locale = Config.Locale[Config.Lang] or Config.Locale['en']

    if Config.Lockpick.item and not PlayerHasItem(src, Config.Lockpick.item) then
        TriggerClientEvent('lxr-lockpick:client:notify', src, locale.no_lockpick, 'error')
        return
    end

    TriggerClientEvent('lxr-lockpick:client:openLockpick', src)
end)

-- Called by client when the minigame resolves (success or failure).
RegisterNetEvent('lxr-lockpick:server:result', function(success, pinBroke)
    local src = source
    local locale = Config.Locale[Config.Lang] or Config.Locale['en']

    -- Remove lockpick on failure (pin broke) if configured
    if pinBroke and Config.Lockpick.removeOnFailure then
        RemoveItemFromPlayer(src, Config.Lockpick.item, 1)
        TriggerClientEvent('lxr-lockpick:client:notify', src, locale.lockpick_removed, 'error')
    end

    -- Remove lockpick on successful open if configured
    if success and Config.Lockpick.removeOnUse then
        RemoveItemFromPlayer(src, Config.Lockpick.item, 1)
    end

    if success then
        TriggerClientEvent('lxr-lockpick:client:notify', src, locale.lockpick_success, 'success')
    else
        TriggerClientEvent('lxr-lockpick:client:notify', src, locale.lockpick_failed, 'error')
    end
end)
