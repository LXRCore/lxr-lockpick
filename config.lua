--[[
    ██╗     ██╗  ██╗██████╗       ██████╗  ██████╗  ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██╔═══██╗██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██║   ██║██║   ██║██████╔╝███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██║   ██║██║   ██║██╔══██╗╚════██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝╚██████╔╝╚██████╔╝██║  ██║███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝

    LXR Core - Lockpick

    A skill-based lockpicking minigame. Another resource (lxr-doors) triggers
    it with a client event and expects a report back when the player finishes:
    TriggerServerEvent(data.report, data.door, broke). The minigame itself is
    framework-agnostic — it only needs lxr-core for Brand and Notify.

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Product:     wolves.land / The Land of Wolves
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/ZHMKVYyhBa (development)
    GitHub:      https://github.com/LXRCore

    Version: 3.0.0
    Performance Target: 0.00 ms idle (no loops; NUI-driven animation)

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

Config = Config or {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Lang = 'en'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GAME ══════════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
Config.Game = {
    pins = 4,               -- number of pins the player must align
    speed = 1.0,            -- sweep speed multiplier (1.0 default)
    band = 0.12,            -- width of the red target zone as a fraction of track (0..0.5)
    breakChance = 0.15,     -- probability the pick snaps on a failed try (0..1)
    maxTries = 3,           -- attempts per pin before it counts as lost
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY ══════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
Config.Security = {
    rateLimit = { windowMs = 2000, burst = 4 },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG ═════════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
Config.Debug = { printBanner = true }
