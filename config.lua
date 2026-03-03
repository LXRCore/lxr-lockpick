--[[
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗  ██████╗██╗  ██╗██████╗ ██╗ ██████╗██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗       ██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔══██╗██║██╔════╝██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝ ─────  ██║     ██║   ██║██║     █████╔╝ ██████╔╝██║██║     █████╔╝
    ██║      ██╔██╗ ██╔══██╗       ██║     ██║   ██║██║     ██╔═██╗ ██╔═══╝ ██║██║     ██╔═██╗
    ███████╗██╔╝ ██╗██║  ██║       ███████╗╚██████╔╝╚██████╗██║  ██╗██║     ██║╚██████╗██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝

    🐺 LXR Lockpick — Advanced Skill-Based Lockpicking Mini-Game
    Immersive, configurable lockpicking experience for your RedM server.

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io

    ═══════════════════════════════════════════════════════════════════════════════

    Version: 1.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact

    Framework Support:
    - LXR Core  (Primary)
    - RSG Core  (Primary)
    - VORP Core (Supported / Legacy)
    - RedEM:RP  (Optional)
    - QBR-Core  (Optional)
    - QR-Core   (Optional)
    - Standalone (Fallback)

    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════

    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Original Concept: LXRCore Lockpick System

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-lockpick"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[

        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════

        Expected: %s
        Got:      %s

        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.

        🐺 wolves.land - The Land of Wolves

        ═══════════════════════════════════════════════════════════════════════════════

    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name        = 'The Land of Wolves 🐺',
    tagline     = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type        = 'Serious Hardcore Roleplay',
    access      = 'Discord & Whitelisted',

    -- Contact & Links
    website   = 'https://www.wolves.land',
    discord   = 'https://discord.gg/CrKcWdfd3A',
    github    = 'https://github.com/iBoss21',
    store     = 'https://theluxempire.tebex.io',

    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core  (Primary)
    2. RSG-Core  (Primary)
    3. VORP Core (Supported / Legacy)
    4. RedEM:RP  (Optional — only if detected)
    5. QBR-Core  (Optional — only if detected)
    6. QR-Core   (Optional — only if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' | 'lxr-core' | 'rsg-core' | 'vorp_core' | 'redem_roleplay' | 'qbr-core' | 'qr-core' | 'standalone'

Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource      = 'lxr-core',
        notifications = 'ox_lib',
        inventory     = 'lxr-inventory',
        events = {
            server   = 'lxr-core:server:%s',
            client   = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s',
        },
    },
    ['rsg-core'] = {
        resource      = 'rsg-core',
        notifications = 'ox_lib',
        inventory     = 'rsg-inventory',
        events = {
            server   = 'RSGCore:Server:%s',
            client   = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s',
        },
    },
    ['vorp_core'] = {
        resource      = 'vorp_core',
        notifications = 'vorp',
        inventory     = 'vorp_inventory',
        events = {
            server = 'vorp:server:%s',
            client = 'vorp:client:%s',
        },
    },
    ['redem_roleplay'] = {
        resource      = 'redem_roleplay',
        notifications = 'redem',
        inventory     = 'redem_inventory',
        events = {
            server = 'redem:%s:server',
            client = 'redem:%s:client',
        },
    },
    ['qbr-core'] = {
        resource      = 'qbr-core',
        notifications = 'ox_lib',
        inventory     = 'qbr-inventory',
        events = {
            server = 'QBR:Server:%s',
            client = 'QBR:Client:%s',
        },
    },
    ['qr-core'] = {
        resource      = 'qr-core',
        notifications = 'ox_lib',
        inventory     = 'qr-inventory',
        events = {
            server = 'QR:Server:%s',
            client = 'QR:Client:%s',
        },
    },
    ['standalone'] = {
        notifications = 'print',
        inventory     = 'none',
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LOCKPICK GAME SETTINGS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lockpick = {
    -- ── Item & Inventory ───────────────────────────────────────────────────────
    -- Name of the lockpick item in your inventory system.
    -- Set to nil / false to disable item requirement (standalone mode).
    item            = 'lockpick',

    -- Whether to remove 1 lockpick from the player's inventory on use.
    removeOnUse     = true,

    -- Whether to remove a lockpick when the pin breaks (failure).
    removeOnFailure = true,

    -- ── Difficulty ─────────────────────────────────────────────────────────────
    -- Number of lockpick pins the player starts with.
    -- Fewer pins = harder (less tolerance for mistakes).
    numPins         = 3,

    -- How much health each pin has (0–100). Lower = breaks faster.
    pinHealth       = 100,

    -- Damage dealt to a pin each time the player pushes the cylinder
    -- while the pick is out of the sweet-spot.
    pinDamage       = 20,

    -- Minimum ms between consecutive pin-damage events (debounce).
    pinDamageInterval = 150,

    -- ── Cylinder & Pick Physics ────────────────────────────────────────────────
    -- Degrees per interval that the cylinder rotates while being pushed.
    cylRotSpeed     = 3,

    -- How far (degrees) the pick can travel left/right from centre.
    maxPickRotation = 90,

    -- Maximum degrees away from the sweet-spot before the cylinder
    -- gets zero rotation allowance.
    maxDistFromSolve = 45,

    -- Padding (degrees) around the sweet-spot that still counts as "solved".
    solvePadding    = 4,

    -- Interval (ms) for the cylinder rotation setInterval loop.
    keyRepeatRate   = 25,

    -- Mouse movement smoothing divisor. Higher = less sensitive.
    mouseSmoothing  = 2,
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- 'en' | 'ge'

Config.Locale = {
    en = {
        no_lockpick        = 'You do not have a lockpick.',
        lockpick_success   = 'You successfully picked the lock!',
        lockpick_failed    = 'You failed to pick the lock.',
        lockpick_removed   = 'Your lockpick broke!',
    },
    ge = {
        no_lockpick        = 'თქვენ არ გაქვთ საკეტის გასახსნელი.',
        lockpick_success   = 'წარმატებით გახსენით საკეტი!',
        lockpick_failed    = 'ვერ გახსენით საკეტი.',
        lockpick_removed   = 'თქვენი გასახსნელი გაფუჭდა!',
    },
}
