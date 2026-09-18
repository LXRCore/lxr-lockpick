## 3.0.0 — 2026-09-17

Rebuilt on the LXRCore v3 API and the LXR UI Kit:

* Native `lxr-lockpick:client:start(data)` event contract (triggered by lxr-doors).
* Reports back via `TriggerServerEvent(data.report, data.door, broke)`.
* Export `Start(data)` for direct calls.
* NUI uses the LXR UI Kit (`html/lxr-ui.css`), two themes (night / morning).
* Config-driven pins, speed, band width, break chance, max tries.
* Locales in `locales/en.lua` + `locales/ka.lua` with full parity.
* Offline tests: config sanity + locale parity + mock output.
