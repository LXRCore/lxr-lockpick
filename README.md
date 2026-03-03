# 🐺 LXR Lockpick

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗  ██████╗██╗  ██╗██████╗ ██╗ ██████╗██╗  ██╗
██║     ╚██╗██╔╝██╔══██╗       ██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔══██╗██║██╔════╝██║ ██╔╝
██║      ╚███╔╝ ██████╔╝ ─────  ██║     ██║   ██║██║     █████╔╝ ██████╔╝██║██║     █████╔╝
██║      ██╔██╗ ██╔══██╗       ██║     ██║   ██║██║     ██╔═██╗ ██╔═══╝ ██║██║     ██╔═██╗
███████╗██╔╝ ██╗██║  ██║       ███████╗╚██████╔╝╚██████╗██║  ██╗██║     ██║╚██████╗██║  ██╗
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝
```

**Advanced skill-based lockpicking mini-game for RedM**

| | |
|---|---|
| **Server** | The Land of Wolves 🐺 |
| **Developer** | iBoss21 / The Lux Empire |
| **Website** | https://www.wolves.land |
| **Discord** | https://discord.gg/CrKcWdfd3A |
| **Store** | https://theluxempire.tebex.io |

---

## Features ✨

- **Interactive Mini-Game** — Skill-based lockpicking with a rotating cylinder and breakable pins.
- **Multi-Framework Support** — LXR Core (primary), RSG Core (primary), VORP Core, RedEM:RP, QBR-Core, QR-Core, Standalone.
- **Item Integration** — Optionally require and consume a `lockpick` item from the player's inventory.
- **Configurable Difficulty** — Adjust pin count, pin health, damage interval, cylinder speed, and sweet-spot size in `config.lua`.
- **Server-Side Validation** — Item checks and removal happen server-side; no client-side exploits.
- **Locale Support** — English and Georgian (`ge`) built in; easily extendable.
- **Resource Name Guard** — Runtime check ensures the folder is named correctly for Tebex escrow compliance.

---

## Framework Support

| Framework | Status |
|---|---|
| LXR Core | ✅ Primary |
| RSG Core | ✅ Primary |
| VORP Core | ✅ Supported |
| RedEM:RP | ⚙️ Optional |
| QBR-Core | ⚙️ Optional |
| QR-Core | ⚙️ Optional |
| Standalone | ✅ Fallback |

---

## Installation 🛠️

### 1. Download & Place

Download the resource and place the folder (named exactly `lxr-lockpick`) inside your `[lxr]` directory.

### 2. Add to `server.cfg`

```bash
ensure lxr-core        # or your chosen framework
ensure lxr-lockpick
```

### 3. Add the lockpick item (optional)

If `Config.Lockpick.item` is set (default: `'lockpick'`), add the item to your inventory resource.

**LXR / RSG example (`items.lua`):**
```lua
['lockpick'] = {
    label    = 'Lockpick',
    weight   = 100,
    type     = 'item',
    image    = 'lockpick.png',
    unique   = false,
    useable  = true,
    shouldClose = true,
    combinable = nil,
    description = 'A small tool used to pick locks.',
},
```

---

## Configuration ⚙️

All settings live in `config.lua`. Key options:

```lua
Config.Framework = 'auto'        -- or 'lxr-core', 'rsg-core', 'vorp_core', etc.

Config.Lockpick = {
    item              = 'lockpick', -- inventory item name (set false to disable)
    removeOnUse       = true,       -- remove on successful open
    removeOnFailure   = true,       -- remove when pin breaks
    numPins           = 3,          -- starting pins (fewer = harder)
    pinHealth         = 100,        -- health per pin
    pinDamage         = 20,         -- damage per bad push
    pinDamageInterval = 150,        -- ms between damage events
    cylRotSpeed       = 3,          -- cylinder rotation speed
    maxPickRotation   = 90,         -- maximum pick rotation (degrees)
    maxDistFromSolve  = 45,         -- tolerance before zero cylinder travel
    solvePadding      = 4,          -- sweet-spot width (degrees)
    keyRepeatRate     = 25,         -- setInterval ms
    mouseSmoothing    = 2,          -- mouse sensitivity divisor
}

Config.Lang = 'en'                -- 'en' | 'ge'
```

---

## Usage Example 🚪

Trigger the lockpick mini-game from another resource:

```lua
-- Client-side: request server to validate item then open the UI
TriggerServerEvent('lxr-lockpick:server:openLockpick')

-- Or, listen for the server-validated open event with a callback:
AddEventHandler('lxr-lockpick:client:openLockpick', function(callback)
    -- The server fires this after a successful item check.
    -- callback will be called with true (success) or false (failure).
end)
```

---

## Roadmap 🚀

- [ ] Lockpick crafting integration
- [ ] Advanced alarm systems for high-value targets
- [ ] Custom RedM animations during picking

---

## License 📄

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

> © 2026 iBoss21 / The Lux Empire | [wolves.land](https://www.wolves.land) | All Rights Reserved
