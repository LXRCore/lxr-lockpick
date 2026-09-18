--[[ ═══════════════════════════════════════════════════════════════════════════
      LXR-LOCKPICK — Offline tests: config sanity + locale parity EN/KA
      Requires a sibling checkout of lxr-core (../lxr-core).
      Usage (from the lxr-lockpick folder):  lua tests/run.lua [--mock out.js en|ka]
      © 2026 iBoss21 / LXRCore — All Rights Reserved
      ═══════════════════════════════════════════════════════════════════════════ ]]

local CORE = os.getenv('LXR_CORE_PATH') or '../lxr-core'
package.path = CORE .. '/?.lua;' .. package.path
local ok = pcall(function() require('tests.lib.fxshim') end)
if not ok then print('lxr-core shim not found at ' .. CORE .. ' (set LXR_CORE_PATH)') os.exit(2) end
local Shim = require('tests.lib.fxshim')

Shim.load('shared/locale.lua')
Shim.load('locales/en.lua')
Shim.load('locales/ka.lua')
Shim.load('config.lua')

local passed, failed = 0, 0
local function test(name, fn)
    local okT, err = xpcall(fn, debug.traceback)
    if okT then passed = passed + 1 print('  ^ ok   ' .. name) else failed = failed + 1 print('  x FAIL ' .. name .. '\n' .. err) end
end
local function eq(a, b, msg) if a ~= b then error((msg or 'eq') .. ': expected ' .. tostring(b) .. ' got ' .. tostring(a), 2) end end

print('lxr-lockpick offline tests')

test('config: pins between 1 and 8', function()
    assert(type(Config.Game.pins) == 'number', 'pins is not a number')
    assert(Config.Game.pins >= 1 and Config.Game.pins <= 8, 'pins out of range: ' .. Config.Game.pins)
end)

test('config: band between 0 and 0.5', function()
    assert(type(Config.Game.band) == 'number', 'band is not a number')
    assert(Config.Game.band > 0 and Config.Game.band <= 0.5, 'band out of range: ' .. Config.Game.band)
end)

test('config: breakChance between 0 and 1', function()
    assert(type(Config.Game.breakChance) == 'number', 'breakChance is not a number')
    assert(Config.Game.breakChance >= 0 and Config.Game.breakChance <= 1, 'breakChance out of range: ' .. Config.Game.breakChance)
end)

test('config: speed positive', function()
    assert(type(Config.Game.speed) == 'number', 'speed is not a number')
    assert(Config.Game.speed > 0, 'speed must be positive: ' .. Config.Game.speed)
end)

test('config: maxTries positive integer', function()
    assert(type(Config.Game.maxTries) == 'number', 'maxTries is not a number')
    assert(Config.Game.maxTries >= 1, 'maxTries must be >= 1: ' .. Config.Game.maxTries)
end)

test('config: rateLimit windowMs and burst positive', function()
    assert(Config.Security.rateLimit.windowMs > 0, 'windowMs must be positive')
    assert(Config.Security.rateLimit.burst > 0, 'burst must be positive')
end)

test('locale parity EN/KA', function()
    local en, ka = Locale.Bundles.en, Locale.Bundles.ka
    local missing = {}
    for k in pairs(en) do if ka[k] == nil then missing[#missing + 1] = k end end
    eq(#missing, 0, 'ka missing: ' .. table.concat(missing, ', '))
end)

test('locale keys present', function()
    assert(Locale.Bundles.en['ui.title'], 'en ui.title missing')
    assert(Locale.Bundles.en['ui.hint'], 'en ui.hint missing')
    assert(Locale.Bundles.en['ui.broke'], 'en ui.broke missing')
    assert(Locale.Bundles.en['ui.done'], 'en ui.done missing')
    assert(Locale.Bundles.ka['ui.title'], 'ka ui.title missing')
    assert(Locale.Bundles.ka['ui.hint'], 'ka ui.hint missing')
    assert(Locale.Bundles.ka['ui.broke'], 'ka ui.broke missing')
    assert(Locale.Bundles.ka['ui.done'], 'ka ui.done missing')
end)

test('Lang.bundle returns flat table with expected keys', function()
    local b = Lang.bundle()
    assert(b['ui.title'], 'bundle missing ui.title')
    assert(b['ui.hint'], 'bundle missing ui.hint')
    assert(b['ui.broke'], 'bundle missing ui.broke')
    assert(b['ui.done'], 'bundle missing ui.done')
end)

print(('%d passed, %d failed'):format(passed, failed))

if arg and arg[1] == '--mock' and arg[2] then
    Config.Lang = arg[3] or 'en'
    local data = {
        action = 'open',
        pins = Config.Game.pins,
        speed = Config.Game.speed,
        band = Config.Game.band,
        label = 'Mock Door',
        locale = Lang.bundle(),
        lang = Config.Lang,
        brand = { name = 'The Land of Wolves', theme = 'night' },
    }
    local f = assert(io.open(arg[2], 'w'))
    -- Use a simple JSON-like encoder for the mock (no dependency needed)
    f:write('window.__LXR_MOCK__ = ' .. json.encode(data) .. ';\n')
    f:close()
    print('mock written to ' .. arg[2])
end

os.exit(failed == 0 and 0 or 1)
