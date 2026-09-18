--[[ ═══════════════════════════════════════════════════════════════════════════
      LXR-LOCKPICK — Client (v3)
      ═══════════════════════════════════════════════════════════════════════════
      Listens for `lxr-lockpick:client:start(data)` from any resource
      (typically lxr-doors). Opens the NUI, handles the result callback,
      and reports back through the data.report event. Also exported as
      Start(data) so other resources can call it directly.

      © 2026 iBoss21 / LXRCore — All Rights Reserved
      ═══════════════════════════════════════════════════════════════════════════ ]]

local running = false
LXRCore = exports['lxr-core']:GetCoreObject()

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ EVENT: lxr-lockpick:client:start(data) ═══════════════
-- ████████████████████████████████████████████████████████████████████████████████
RegisterNetEvent('lxr-lockpick:client:start', function(data)
    if running then return end
    running = true

    SetNuiFocus(true, true)
    SendNUIMessage({
        action  = 'open',
        pins    = Config.Game.pins,
        speed   = Config.Game.speed,
        band    = Config.Game.band,
        label   = data.label,
        locale  = Lang.bundle(),
        brand   = LXRCore.Brand,
        lang    = Config.Lang,
    })
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NUI CALLBACKS ════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
RegisterNUICallback('result', function(data, cb)
    SetNuiFocus(false, false)

    if data.ok then
        -- Successful pick: report to the triggering resource.
        TriggerServerEvent(data.report, data.door, false)
    elseif data.broke then
        -- Pick snapped.
        LXRCore.Notify(Lang:t('ui.broke'), 'error')
        TriggerServerEvent(data.report, data.door, true)
    else
        -- Failed without breaking (shouldn't happen, but be safe).
        LXRCore.Notify(Lang:t('ui.broke'), 'error')
    end

    running = false
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    running = false
    cb('ok')
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ EXPORT: Start(data) ══════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
exports('Start', function(data)
    if running then return end
    TriggerEvent('lxr-lockpick:client:start', data)
end)
