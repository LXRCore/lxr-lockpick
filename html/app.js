/* ==========================================================================
   LXR-LOCKPICK — Minigame logic
   ========================================================================== */

(function () {
    'use strict';

    // --- State ----------------------------------------------------------
    let cfg = null;            // { pins, speed, band, label, locale, brand, lang }
    let pinCount = 0;
    let pinStates = [];        // per-pin: { pos, direction, bandPos, bandWidth, set, triesLeft, active }
    let animFrame = null;
    let currentPin = 0;
    let gameDone = false;

    // --- Mock support ---------------------------------------------------
    if (window.__LXR_MOCK__) {
        openMock(window.__LXR_MOCK__);
        return;
    }

    // --- NUI message handler --------------------------------------------
    window.addEventListener('message', function (ev) {
        const msg = ev.data;
        if (!msg || !msg.action) return;
        if (msg.action === 'open') openGame(msg);
    });

    // --- Key handlers ---------------------------------------------------
    document.addEventListener('keydown', function (ev) {
        if (gameDone) return;
        if (ev.code === 'Space') {
            ev.preventDefault();
            attemptPin();
        } else if (ev.code === 'Escape') {
            closeGame();
        }
    });

    // --- Open -----------------------------------------------------------
    function openGame(data) {
        cfg = data;
        pinCount = data.pins || 4;
        gameDone = false;
        currentPin = 0;

        // Theme
        const theme = (data.brand && data.brand.theme) || 'night';
        document.documentElement.dataset.theme = theme;

        // Locale
        document.getElementById('brand-label').textContent = (data.brand && data.brand.name) || '';
        document.getElementById('title').textContent = data.locale && data.locale['ui.title'] || 'Pick the lock';
        const hintEl = document.getElementById('hint');
        hintEl.textContent = data.locale && data.locale['ui.hint'] || 'Press SPACE when the pin sits in the red band';
        if (data.lang === 'ka') hintEl.classList.add('lxr-ka');

        // Build pins
        const container = document.getElementById('pins');
        container.innerHTML = '';
        pinStates = [];

        for (let i = 0; i < pinCount; i++) {
            const bandPos = Math.random() * (1 - data.band) + data.band / 2; // random position within track
            pinStates.push({
                pos: 0,           // 0..1 position along track
                direction: 1,     // 1 = right, -1 = left
                bandPos: bandPos,
                bandwidth: data.band,
                set: false,
                triesLeft: data.maxTries || 3,
                active: i === 0,
            });

            const row = document.createElement('div');
            row.className = 'lxr-pin-row' + (i === 0 ? ' is-active' : '');
            row.dataset.index = i;

            row.innerHTML =
                '<span class="lxr-pin-label">' + String(i + 1).padStart(2, '0') + '</span>' +
                '<div class="lxr-pin-track">' +
                    '<div class="lxr-pin-band" style="left:' + (bandPos * 100) + '%; width:' + (data.band * 100) + '%;"></div>' +
                    '<div class="lxr-pin-marker" style="left:0%;"></div>' +
                '</div>';

            container.appendChild(row);
        }

        updateStatus();
        startAnimation();
    }

    // --- Animation loop -------------------------------------------------
    function startAnimation() {
        if (animFrame) cancelAnimationFrame(animFrame);
        let lastTime = performance.now();

        function tick(now) {
            if (gameDone) return;
            const dt = (now - lastTime) / 1000;
            lastTime = now;

            // Only animate the active pin
            const ps = pinStates[currentPin];
            if (ps && !ps.set) {
                const speed = cfg.speed || 1.0;
                // Base sweep speed: traverse full track in ~2 seconds at speed=1
                const baseSpeed = 0.5;
                ps.pos += ps.direction * baseSpeed * speed * dt;

                if (ps.pos >= 1) { ps.pos = 1; ps.direction = -1; }
                if (ps.pos <= 0) { ps.pos = 0; ps.direction = 1; }

                // Update marker position
                const row = document.querySelector('.lxr-pin-row[data-index="' + currentPin + '"]');
                if (row) {
                    const marker = row.querySelector('.lxr-pin-marker');
                    if (marker) marker.style.left = (ps.pos * 100) + '%';
                }
            }

            animFrame = requestAnimationFrame(tick);
        }

        animFrame = requestAnimationFrame(tick);
    }

    // --- Attempt a pin --------------------------------------------------
    function attemptPin() {
        const ps = pinStates[currentPin];
        if (!ps || ps.set) return;

        // Check if pin is within the band
        const distToBandCenter = Math.abs(ps.pos - ps.bandPos);
        const inBand = distToBandCenter <= ps.bandwidth / 2;

        if (inBand) {
            // Success: set the pin
            ps.set = true;
            const row = document.querySelector('.lxr-pin-row[data-index="' + currentPin + '"]');
            if (row) {
                row.classList.add('is-ok', 'is-done');
                row.classList.remove('is-active');
                // Snap marker to band center
                const marker = row.querySelector('.lxr-pin-marker');
                if (marker) marker.style.left = (ps.bandPos * 100) + '%';
            }

            // Move to next unset pin, or finish
            advancePin();
        } else {
            // Miss: lose a try
            ps.triesLeft--;
            const row = document.querySelector('.lxr-pin-row[data-index="' + currentPin + '"]');
            if (row) {
                row.classList.add('is-miss');
                setTimeout(function () { if (row) row.classList.remove('is-miss'); }, 300);
            }

            updateStatus();

            if (ps.triesLeft <= 0) {
                // Exhausted tries on this pin — game over
                endGame(false, false);
            }
        }
    }

    // --- Advance to next active pin -------------------------------------
    function advancePin() {
        // Find next unset pin
        let found = -1;
        for (let i = 0; i < pinStates.length; i++) {
            if (!pinStates[i].set) { found = i; break; }
        }

        if (found === -1) {
            // All pins set — success!
            endGame(true, false);
            return;
        }

        // Deactivate current, activate next
        const prevRow = document.querySelector('.lxr-pin-row[data-index="' + currentPin + '"]');
        if (prevRow) prevRow.classList.remove('is-active');

        currentPin = found;
        pinStates[currentPin].active = true;
        const newRow = document.querySelector('.lxr-pin-row[data-index="' + currentPin + '"]');
        if (newRow) newRow.classList.add('is-active');

        updateStatus();
    }

    // --- End game -------------------------------------------------------
    function endGame(ok, broke) {
        gameDone = true;
        if (animFrame) cancelAnimationFrame(animFrame);

        if (!ok) {
            // Randomly decide if the pick snapped
            const doBreak = Math.random() < (cfg.breakChance || 0.15);
            postResult(false, doBreak);
        } else {
            postResult(true, false);
        }
    }

    // --- Post result to game --------------------------------------------
    function postResult(ok, broke) {
        const door = cfg.door || null;
        const report = cfg.report || null;

        fetch('https://' + GetCurrentResourceName() + '/result', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ok: ok, broke: broke, door: door, report: report }),
        });
    }

    // --- Close ----------------------------------------------------------
    function closeGame() {
        gameDone = true;
        if (animFrame) cancelAnimationFrame(animFrame);
        fetch('https://' + GetCurrentResourceName() + '/close', { method: 'POST' });
    }

    // --- Status update --------------------------------------------------
    function updateStatus() {
        const statusEl = document.getElementById('status');
        const triesEl = document.getElementById('tries');

        let setCount = 0;
        for (let i = 0; i < pinStates.length; i++) {
            if (pinStates[i].set) setCount++;
        }

        statusEl.textContent = setCount + ' / ' + pinCount + ' set';

        const ps = pinStates[currentPin];
        if (ps) {
            triesEl.textContent = ps.triesLeft + ' tries left';
        } else {
            triesEl.textContent = '';
        }
    }

    // --- Mock mode ------------------------------------------------------
    function openMock(mockData) {
        cfg = mockData;
        pinCount = mockData.pins || 4;
        gameDone = false;
        currentPin = 0;

        const theme = (mockData.brand && mockData.brand.theme) || 'night';
        document.documentElement.dataset.theme = theme;

        document.getElementById('brand-label').textContent = (mockData.brand && mockData.brand.name) || '';
        document.getElementById('title').textContent = mockData.locale && mockData.locale['ui.title'] || 'Pick the lock';
        const hintEl = document.getElementById('hint');
        hintEl.textContent = mockData.locale && mockData.locale['ui.hint'] || 'Press SPACE when the pin sits in the red band';
        if (mockData.lang === 'ka') hintEl.classList.add('lxr-ka');

        const container = document.getElementById('pins');
        container.innerHTML = '';
        pinStates = [];

        for (let i = 0; i < pinCount; i++) {
            const bandPos = Math.random() * (1 - mockData.band) + mockData.band / 2;
            pinStates.push({
                pos: 0, direction: 1, bandPos: bandPos, bandwidth: mockData.band,
                set: false, triesLeft: mockData.maxTries || 3, active: i === 0,
            });

            const row = document.createElement('div');
            row.className = 'lxr-pin-row' + (i === 0 ? ' is-active' : '');
            row.dataset.index = i;
            row.innerHTML =
                '<span class="lxr-pin-label">' + String(i + 1).padStart(2, '0') + '</span>' +
                '<div class="lxr-pin-track">' +
                    '<div class="lxr-pin-band" style="left:' + (bandPos * 100) + '%; width:' + (mockData.band * 100) + '%;"></div>' +
                    '<div class="lxr-pin-marker" style="left:0%;"></div>' +
                '</div>';
            container.appendChild(row);
        }

        updateStatus();
        startAnimation();
    }
})();
