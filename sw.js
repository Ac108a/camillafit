const CACHE_NAME = 'camillafit-v5';
const ASSETS = [
    './',
    './index.html',
    './style.css',
    './app.js',
    './manifest.json',
    './icon-192.png',
    './icon-512.png',
    './gifs/strength_cover.webp',
    './gifs/yoga_cover.webp',
    './gifs/goblet_squat.gif',
    './gifs/romanian_deadlift.gif',
    './gifs/kettlebell_swing.gif',
    './gifs/floor_press.gif',
    './gifs/bent_over_row.gif',
    './gifs/reverse_lunge.gif',
    './gifs/clean_and_press.gif',
    './gifs/dumbbell_thruster.gif',
    './gifs/sumo_deadlift.gif',
    './gifs/renegade_row.gif',
    './gifs/cat_cow_flow.gif',
    './gifs/downward_dog.gif',
    './gifs/warrior_i.gif',
    './gifs/warrior_ii.gif',
    './gifs/pilates_hundred.gif',
    './gifs/bridge_pose.gif',
    './gifs/pilates_swimming.gif',
    './gifs/pigeon_pose.gif',
    './gifs/seated_spinal_twist.gif',
    './gifs/childs_pose.gif'
];

self.addEventListener('install', e => {
    e.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(ASSETS))
            .then(() => self.skipWaiting())
    );
});

self.addEventListener('activate', e => {
    e.waitUntil(
        caches.keys().then(keys =>
            Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
        ).then(() => self.clients.claim())
    );
});

self.addEventListener('fetch', e => {
    e.respondWith(
        caches.match(e.request).then(r => r || fetch(e.request))
    );
});
