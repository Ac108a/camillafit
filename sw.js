const CACHE_NAME = 'camillafit-v6';
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
    './gifs/goblet_squat.mp4',
    './gifs/romanian_deadlift.mp4',
    './gifs/kettlebell_swing.mp4',
    './gifs/floor_press.mp4',
    './gifs/bent_over_row.mp4',
    './gifs/reverse_lunge.mp4',
    './gifs/clean_and_press.mp4',
    './gifs/dumbbell_thruster.mp4',
    './gifs/sumo_deadlift.mp4',
    './gifs/renegade_row.mp4',
    './gifs/cat_cow_flow.mp4',
    './gifs/downward_dog.mp4',
    './gifs/warrior_i.mp4',
    './gifs/warrior_ii.mp4',
    './gifs/pilates_hundred.mp4',
    './gifs/bridge_pose.mp4',
    './gifs/pilates_swimming.mp4',
    './gifs/pigeon_pose.mp4',
    './gifs/seated_spinal_twist.mp4',
    './gifs/childs_pose.mp4'
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
