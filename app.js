// ===== CamillaFit PWA =====

// ---- Service Worker Registration ----
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('sw.js').catch(() => {});
}

// ---- Theme ----
function getTheme() {
    return localStorage.getItem('cf-theme') || 'light';
}
function setTheme(t) {
    document.documentElement.setAttribute('data-theme', t);
    localStorage.setItem('cf-theme', t);
}
function toggleTheme() {
    setTheme(getTheme() === 'dark' ? 'light' : 'dark');
    render();
}
setTheme(getTheme());

// ---- Workout Data ----
const WORKOUTS = {
    strength: {
        type: 'strength',
        title: 'Strength Training',
        subtitle: 'Weight Loss Focus',
        icon: '\u{1F525}',
        coverImg: 'strength_cover.webp',
        equipmentSummary: 'Dumbbells, Kettlebell, Barbell',
        workDuration: 40,
        restDuration: 15,
        introDuration: 5,
        exercises: [
            { name: 'Goblet Squat', desc: 'Hold kettlebell at chest. Squat deep, elbows between knees. Drive through heels.', equipment: 'Kettlebell', target: 'Legs / Glutes', icon: '\u{1F3CB}', gif: 'goblet_squat.gif' },
            { name: 'Romanian Deadlift', desc: 'Dumbbells in front of thighs. Hinge at hips, slight knee bend. Feel the hamstring stretch.', equipment: 'Dumbbells', target: 'Hamstrings / Back', icon: '\u{1F4AA}', gif: 'romanian_deadlift.gif' },
            { name: 'Kettlebell Swing', desc: 'Hinge and snap hips forward. Arms are just along for the ride. Power from the glutes.', equipment: 'Kettlebell', target: 'Full Body / Cardio', icon: '\u{26A1}', gif: 'kettlebell_swing.gif' },
            { name: 'Floor Press', desc: 'Lie on floor, dumbbells above chest. Lower until elbows touch floor, press up.', equipment: 'Dumbbells', target: 'Chest / Triceps', icon: '\u{1F3CB}', gif: 'floor_press.gif' },
            { name: 'Bent-Over Row', desc: 'Hinge forward 45\u00B0, barbell hanging. Pull to lower chest, squeeze shoulder blades.', equipment: 'Barbell', target: 'Back / Biceps', icon: '\u{1F4AA}', gif: 'bent_over_row.gif' },
            { name: 'Reverse Lunge', desc: 'Dumbbells at sides. Step back into lunge, knee just above floor. Alternate legs.', equipment: 'Dumbbells', target: 'Legs / Glutes', icon: '\u{1F6B6}', gif: 'reverse_lunge.gif' },
            { name: 'Clean & Press', desc: 'Kettlebell from floor to shoulder (clean), then press overhead. Alternate sides.', equipment: 'Kettlebell', target: 'Shoulders / Full Body', icon: '\u{1F3CB}', gif: 'clean_and_press.gif' },
            { name: 'Dumbbell Thruster', desc: 'Dumbbells at shoulders. Squat down, then drive up and press overhead in one motion.', equipment: 'Dumbbells', target: 'Full Body / Cardio', icon: '\u{26A1}', gif: 'dumbbell_thruster.gif' },
            { name: 'Sumo Deadlift', desc: 'Wide stance, kettlebell between feet. Keep chest up, drive through heels to stand.', equipment: 'Kettlebell', target: 'Legs / Back', icon: '\u{1F4AA}', gif: 'sumo_deadlift.gif' },
            { name: 'Renegade Row', desc: 'Plank on dumbbells. Row one dumbbell up, stabilize with core. Alternate sides.', equipment: 'Dumbbells', target: 'Core / Back', icon: '\u{1F9D8}', gif: 'renegade_row.gif' },
        ]
    },
    pilates: {
        type: 'pilates',
        title: 'Pilates & Yoga',
        subtitle: 'Mobility & Flexibility',
        icon: '\u{1F33F}',
        coverImg: 'yoga_cover.webp',
        equipmentSummary: 'Bodyweight Only',
        workDuration: 50,
        restDuration: 10,
        introDuration: 5,
        exercises: [
            { name: 'Cat-Cow Flow', desc: 'On all fours. Inhale: arch back, look up (cow). Exhale: round spine, tuck chin (cat).', equipment: 'Bodyweight', target: 'Spine Mobility', icon: '\u{1F9D8}', gif: 'cat_cow_flow.gif' },
            { name: 'Downward Dog', desc: 'Inverted V shape. Push hips up and back, heels toward floor. Pedal feet to loosen.', equipment: 'Bodyweight', target: 'Full Body Stretch', icon: '\u{1F9D8}', gif: 'downward_dog.gif' },
            { name: 'Warrior I', desc: 'Front knee bent 90\u00B0, back leg straight. Arms overhead. Switch sides halfway.', equipment: 'Bodyweight', target: 'Hip Flexors / Balance', icon: '\u{1F9D8}', gif: 'warrior_i.gif' },
            { name: 'Warrior II', desc: 'Wide stance, front knee over ankle. Arms extended wide. Gaze over front hand. Switch halfway.', equipment: 'Bodyweight', target: 'Hip Opening / Legs', icon: '\u{1F9D8}', gif: 'warrior_ii.gif' },
            { name: 'Pilates Hundred', desc: 'Legs at 45\u00B0, head and shoulders up. Pump arms vigorously. Breathe: 5 counts in, 5 out.', equipment: 'Bodyweight', target: 'Core Activation', icon: '\u{1F525}', gif: 'pilates_hundred.gif' },
            { name: 'Bridge Pose', desc: 'Lie on back, feet flat. Lift hips high, squeeze glutes. Hold or pulse gently.', equipment: 'Bodyweight', target: 'Glutes / Spine', icon: '\u{1F9D8}', gif: 'bridge_pose.gif' },
            { name: 'Pilates Swimming', desc: 'Lie face down, arms forward. Lift opposite arm and leg, alternate quickly. Keep core tight.', equipment: 'Bodyweight', target: 'Back / Core', icon: '\u{1F3CA}', gif: 'pilates_swimming.gif' },
            { name: 'Pigeon Pose', desc: 'Front shin across mat, back leg extended. Fold forward over front leg. Switch halfway.', equipment: 'Bodyweight', target: 'Hip Stretch', icon: '\u{1F9D8}', gif: 'pigeon_pose.gif' },
            { name: 'Seated Spinal Twist', desc: 'Sit tall, cross one leg over other. Twist toward bent knee. Switch sides halfway.', equipment: 'Bodyweight', target: 'Spine Mobility', icon: '\u{1F9D8}', gif: 'seated_spinal_twist.gif' },
            { name: 'Child\'s Pose', desc: 'Knees wide, big toes touching. Reach arms forward, forehead to mat. Breathe deeply.', equipment: 'Bodyweight', target: 'Recovery / Stretch', icon: '\u{1F64F}', gif: 'childs_pose.gif' },
        ]
    }
};

// ---- Audio Manager ----
const Audio = (() => {
    let ctx = null;

    function getCtx() {
        if (!ctx) ctx = new (window.AudioContext || window.webkitAudioContext)();
        if (ctx.state === 'suspended') ctx.resume();
        return ctx;
    }

    function beep(freq, duration, type = 'sine') {
        try {
            const c = getCtx();
            const osc = c.createOscillator();
            const gain = c.createGain();
            osc.type = type;
            osc.frequency.value = freq;
            gain.gain.value = 0.3;
            gain.gain.exponentialRampToValueAtTime(0.001, c.currentTime + duration);
            osc.connect(gain);
            gain.connect(c.destination);
            osc.start(c.currentTime);
            osc.stop(c.currentTime + duration);
        } catch (e) {}
    }

    return {
        transitionBeep() { beep(880, 0.15); },
        countdownBeep() { beep(660, 0.1, 'triangle'); },
        workoutEndBeeps() {
            beep(880, 0.15);
            setTimeout(() => beep(880, 0.15), 200);
            setTimeout(() => beep(1320, 0.3), 400);
        },
        speak(text) {
            if (!('speechSynthesis' in window)) return;
            speechSynthesis.cancel();
            const u = new SpeechSynthesisUtterance(text);
            u.lang = 'en-US'; u.rate = 0.9; u.volume = 0.8; u.pitch = 1.1;
            speechSynthesis.speak(u);
        },
        stopSpeaking() {
            if ('speechSynthesis' in window) speechSynthesis.cancel();
        },
        vibrate(ms = 50) {
            if (navigator.vibrate) navigator.vibrate(ms);
        },
        unlock() {
            try {
                const c = getCtx();
                const b = c.createBuffer(1, 1, 22050);
                const s = c.createBufferSource();
                s.buffer = b; s.connect(c.destination); s.start(0);
            } catch (e) {}
            if ('speechSynthesis' in window) {
                const u = new SpeechSynthesisUtterance('');
                u.volume = 0; speechSynthesis.speak(u);
            }
        }
    };
})();

// ---- Wake Lock ----
let wakeLock = null;
async function requestWakeLock() {
    try { if ('wakeLock' in navigator) wakeLock = await navigator.wakeLock.request('screen'); } catch (e) {}
}
function releaseWakeLock() {
    if (wakeLock) { wakeLock.release().catch(() => {}); wakeLock = null; }
}

// ---- App State ----
const state = {
    screen: 'home',
    workout: null,
    phase: 'intro',
    exerciseIndex: 0,
    timeRemaining: 0,
    totalElapsed: 0,
    isPaused: false,
    timerId: null,
};

// ---- Computed ----
function totalDuration(w) {
    return w.introDuration + w.exercises.length * w.workDuration + (w.exercises.length - 1) * w.restDuration;
}
function totalMinutes(w) { return Math.floor(totalDuration(w) / 60); }
function phaseDuration() {
    const w = state.workout;
    if (state.phase === 'intro') return w.introDuration;
    if (state.phase === 'work') return w.workDuration;
    if (state.phase === 'rest') return w.restDuration;
    return 0;
}
function progress() {
    const pd = phaseDuration();
    return pd <= 0 ? 1 : 1 - (state.timeRemaining / pd);
}
function overallProgress() {
    const td = totalDuration(state.workout);
    return td <= 0 ? 0 : state.totalElapsed / td;
}

// ---- Navigation ----
function navigate(screen) { state.screen = screen; render(); }
function showHome() {
    stopTimer(); releaseWakeLock();
    state.workout = null; state.isPaused = false;
    navigate('home');
}
function showPreview(type) { state.workout = WORKOUTS[type]; navigate('preview'); }
function startWorkout() {
    Audio.unlock();
    state.phase = 'intro';
    state.exerciseIndex = 0;
    state.timeRemaining = state.workout.introDuration;
    state.totalElapsed = 0;
    state.isPaused = false;
    requestWakeLock();
    navigate('active');
    Audio.speak('Get ready!');
    startTimer();
}

// ---- Timer ----
function startTimer() { stopTimer(); state.timerId = setInterval(tick, 1000); }
function stopTimer() { if (state.timerId) { clearInterval(state.timerId); state.timerId = null; } }
function tick() {
    if (state.isPaused) return;
    state.totalElapsed++;
    if (state.timeRemaining > 1) {
        state.timeRemaining--;
        if (state.timeRemaining <= 3) {
            Audio.countdownBeep();
            if (state.phase === 'rest' || state.phase === 'intro') Audio.speak(String(state.timeRemaining));
        }
        updateActiveTimer();
    } else {
        advancePhase();
        renderActive();
    }
}
function advancePhase() {
    Audio.transitionBeep(); Audio.vibrate(50);
    const w = state.workout;
    switch (state.phase) {
        case 'intro':
            state.phase = 'work'; state.timeRemaining = w.workDuration;
            Audio.speak(w.exercises[state.exerciseIndex].name); break;
        case 'work':
            if (state.exerciseIndex < w.exercises.length - 1) {
                state.phase = 'rest'; state.timeRemaining = w.restDuration;
                Audio.speak('Rest. Next up: ' + w.exercises[state.exerciseIndex + 1].name);
            } else { completeWorkout(); return; }
            break;
        case 'rest':
            state.exerciseIndex++; state.phase = 'work'; state.timeRemaining = w.workDuration;
            Audio.speak(w.exercises[state.exerciseIndex].name); break;
    }
}
function completeWorkout() {
    stopTimer(); state.phase = 'completed';
    Audio.workoutEndBeeps(); Audio.vibrate([100, 50, 100, 50, 200]);
    releaseWakeLock();
    setTimeout(() => Audio.speak('Great job! Workout complete!'), 600);
    navigate('complete');
}
function togglePause() {
    state.isPaused = !state.isPaused;
    if (state.isPaused) Audio.stopSpeaking();
    renderActive();
}
function skipExercise() {
    if (state.phase === 'completed') return;
    const w = state.workout;
    state.totalElapsed += state.timeRemaining;
    if (state.phase === 'intro') {
        state.phase = 'work'; state.timeRemaining = w.workDuration;
        Audio.transitionBeep(); Audio.speak(w.exercises[state.exerciseIndex].name);
    } else if (state.phase === 'work') {
        if (state.exerciseIndex < w.exercises.length - 1) {
            state.phase = 'rest'; state.timeRemaining = w.restDuration;
            Audio.transitionBeep(); Audio.speak('Rest. Next up: ' + w.exercises[state.exerciseIndex + 1].name);
        } else { completeWorkout(); return; }
    } else if (state.phase === 'rest') {
        state.exerciseIndex++; state.phase = 'work'; state.timeRemaining = w.workDuration;
        Audio.transitionBeep(); Audio.speak(w.exercises[state.exerciseIndex].name);
    }
    renderActive();
}

// ---- Helpers ----
function exerciseImg(ex, cssClass) {
    if (ex.gif) {
        const mp4 = 'gifs/' + ex.gif.replace('.gif', '.mp4');
        return `<video src="${mp4}" class="${cssClass}" autoplay loop muted playsinline onloadeddata="this.playbackRate=0.33" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"></video><span class="${cssClass}-fallback" style="display:none">${ex.icon}</span>`;
    }
    return `<span class="${cssClass}-fallback">${ex.icon}</span>`;
}
function timerRingSVG(prog, color) {
    const r = 54;
    const circ = 2 * Math.PI * r;
    const offset = circ * (1 - Math.min(prog, 1));
    return `<svg class="timer-ring-svg" viewBox="0 0 130 130">
        <circle class="timer-ring-bg" cx="65" cy="65" r="${r}"/>
        <circle class="timer-ring-fg" cx="65" cy="65" r="${r}"
            stroke="${color}" stroke-dasharray="${circ}" stroke-dashoffset="${offset}"/>
    </svg>`;
}
function phaseColor() {
    if (state.phase === 'work') return 'var(--green)';
    if (state.phase === 'rest') return 'var(--orange)';
    if (state.phase === 'intro') return 'var(--blue)';
    return 'var(--accent)';
}
function phaseLabel() {
    if (state.phase === 'work') return 'WORK';
    if (state.phase === 'rest') return 'REST';
    if (state.phase === 'intro') return 'GET READY';
    return 'DONE';
}
function phaseCSSClass() { return 'phase-' + state.phase; }
function dotClass(i) {
    if (i < state.exerciseIndex) return 'dot done';
    if (i === state.exerciseIndex) {
        if (state.phase === 'work') return 'dot current-work';
        if (state.phase === 'rest') return 'dot current-rest';
        if (state.phase === 'intro') return 'dot current-intro';
    }
    return 'dot';
}
function themeIcon() {
    return getTheme() === 'dark' ? '\u{263E}' : '\u{2600}';
}

// ---- Partial DOM Update (avoids destroying <video> elements) ----
function updateActiveTimer() {
    const prog = progress();
    const overall = overallProgress();
    const color = phaseColor();
    const r = 54;
    const circ = 2 * Math.PI * r;
    const offset = circ * (1 - Math.min(prog, 1));

    const timeEl = document.querySelector('.timer-time');
    if (timeEl) timeEl.textContent = state.timeRemaining;

    const ringFg = document.querySelector('.timer-ring-fg');
    if (ringFg) {
        ringFg.setAttribute('stroke', color);
        ringFg.setAttribute('stroke-dashoffset', offset);
    }

    const pctEl = document.querySelector('.workout-percent');
    if (pctEl) pctEl.textContent = Math.round(overall * 100) + '%';

    const phaseEl = document.querySelector('.phase-label');
    if (phaseEl) {
        phaseEl.textContent = phaseLabel();
        phaseEl.className = 'phase-label ' + phaseCSSClass();
    }

    const dots = document.querySelectorAll('.progress-dots .dot');
    const w = state.workout;
    dots.forEach((dot, i) => { dot.className = dotClass(i); });
}

// ---- Render ----
const app = document.getElementById('app');

function render() {
    switch (state.screen) {
        case 'home': return renderHome();
        case 'preview': return renderPreview();
        case 'active': return renderActive();
        case 'complete': return renderComplete();
    }
}

function renderHome() {
    const workouts = [WORKOUTS.strength, WORKOUTS.pilates];
    app.innerHTML = `
        <div class="screen active">
            <div class="top-bar">
                <div class="top-bar-title">CamillaFit</div>
                <div class="top-bar-actions">
                    <button class="btn-circle" onclick="toggleTheme()">${themeIcon()}</button>
                </div>
            </div>
            <div class="home-greeting">Choose your training</div>
            <div class="screen-scroll">
                <div class="training-section-title">Programs</div>
                <div class="training-cards">
                    ${workouts.map(w => `
                        <div class="training-card" onclick="showPreview('${w.type}')">
                            <div class="training-card-img">
                                <img src="gifs/${w.coverImg}" alt="${w.title}" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                <span class="card-img-fallback" style="display:none">${w.icon}</span>
                                <div class="training-card-overlay"></div>
                            </div>
                            <div class="training-card-body">
                                <div class="training-card-title">${w.title}</div>
                                <div class="training-card-sub">${w.subtitle}</div>
                                <div class="training-card-chips">
                                    <span class="chip chip-accent">${totalMinutes(w)} min</span>
                                    <span class="chip">${w.exercises.length} exercises</span>
                                    <span class="chip">${w.workDuration}s / ${w.restDuration}s</span>
                                    <span class="chip">${w.equipmentSummary}</span>
                                </div>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        </div>`;
}

function renderPreview() {
    const w = state.workout;
    app.innerHTML = `
        <div class="screen active">
            <div class="preview-top">
                <button class="preview-back" onclick="showHome()">\u{2190}</button>
                <div class="preview-top-title">${w.title}</div>
            </div>
            <div class="preview-hero">
                <div class="preview-chips">
                    <span class="chip chip-accent">${totalMinutes(w)} min</span>
                    <span class="chip">${w.exercises.length} exercises</span>
                    <span class="chip">${w.workDuration}s work / ${w.restDuration}s rest</span>
                </div>
            </div>
            <div class="screen-scroll">
                <div class="exercise-list">
                    ${w.exercises.map((ex, i) => `
                        <div class="exercise-card">
                            <span class="exercise-num">${i + 1}</span>
                            <div class="exercise-icon-box">${exerciseImg(ex, 'exercise-gif')}</div>
                            <div class="exercise-info">
                                <div class="exercise-name">${ex.name}</div>
                                <div class="exercise-desc">${ex.desc}</div>
                                <div class="exercise-tags">
                                    <span class="tag tag-equipment">${ex.equipment}</span>
                                    <span class="tag-target">${ex.target}</span>
                                </div>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
            <div class="start-btn-wrap">
                <button class="start-btn" onclick="startWorkout()">Start Workout</button>
            </div>
        </div>`;
}

function renderActive() {
    const w = state.workout;
    const ex = w.exercises[state.exerciseIndex];
    const next = state.exerciseIndex < w.exercises.length - 1
        ? w.exercises[state.exerciseIndex + 1] : null;
    const prog = progress();
    const overall = overallProgress();
    const color = phaseColor();

    let exerciseArea = '';
    if (state.phase === 'rest' && next) {
        exerciseArea = `
            <div class="rest-area">
                <div class="rest-label">Rest</div>
                <div class="rest-next-label">Next up</div>
                <div class="rest-next-icon">${exerciseImg(next, 'rest-gif')}</div>
                <div class="rest-next-name">${next.name}</div>
                <div class="rest-next-equip">${next.equipment}</div>
            </div>`;
    } else {
        exerciseArea = `
            <div class="active-exercise-area">
                <div class="active-exercise-icon">${exerciseImg(ex, 'active-gif')}</div>
                <div class="active-exercise-name">${ex.name}</div>
                <div class="active-exercise-equip">${ex.equipment}</div>
                <div class="active-exercise-desc">${ex.desc}</div>
            </div>`;
    }

    app.innerHTML = `
        <div class="screen active">
            <div class="workout-top-bar">
                <button class="btn-icon" onclick="showHome()">\u{2715}</button>
                <span class="workout-title-bar">${w.title}</span>
                <span class="workout-percent">${Math.round(overall * 100)}%</span>
            </div>
            <div class="progress-dots">
                ${w.exercises.map((_, i) => `<div class="${dotClass(i)}"></div>`).join('')}
            </div>
            ${exerciseArea}
            <div class="timer-section">
                <div class="timer-ring-wrap">
                    ${timerRingSVG(prog, color)}
                    <div class="timer-time">${state.timeRemaining}</div>
                </div>
                <div class="phase-label ${phaseCSSClass()}">${phaseLabel()}</div>
                <div class="workout-controls">
                    <button class="ctrl-btn" onclick="togglePause()">\u{23F8}</button>
                    <button class="ctrl-btn" onclick="skipExercise()">\u{23ED}</button>
                </div>
            </div>
            <div class="pause-overlay ${state.isPaused ? 'visible' : ''}">
                <div class="pause-overlay-icon">\u{23F8}\uFE0F</div>
                <div class="pause-overlay-text">Paused</div>
                <div class="pause-buttons">
                    <button class="btn-resume" onclick="togglePause()">Resume</button>
                    <button class="btn-quit" onclick="showHome()">Quit Workout</button>
                </div>
            </div>
        </div>`;
}

function renderComplete() {
    const w = state.workout;
    app.innerHTML = `
        <div class="screen active">
            <div class="completion-content">
                <div class="completion-check" id="checkAnim">\u{2713}</div>
                <div class="completion-title">Well Done!</div>
                <div class="completion-subtitle">You completed ${w.title}</div>
                <div class="completion-stats">
                    <div class="stat-box">
                        <div class="stat-icon">\u{1F553}</div>
                        <div class="stat-value">${totalMinutes(w)}</div>
                        <div class="stat-label">Minutes</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-icon">\u{1F4CB}</div>
                        <div class="stat-value">${w.exercises.length}</div>
                        <div class="stat-label">Exercises</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-icon">\u{1F525}</div>
                        <div class="stat-value">100%</div>
                        <div class="stat-label">Complete</div>
                    </div>
                </div>
            </div>
            <div class="home-btn-wrap">
                <button class="home-btn" onclick="showHome()">Back to Home</button>
            </div>
        </div>`;

    requestAnimationFrame(() => {
        requestAnimationFrame(() => {
            const el = document.getElementById('checkAnim');
            if (el) el.classList.add('pop');
        });
    });
}

// ---- Init ----
renderHome();
