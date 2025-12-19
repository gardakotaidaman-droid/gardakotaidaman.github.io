// Service Worker untuk Garda Kota Idaman PWA
// Version: 1.0
// Updated: 2025-12-19

const CACHE_NAME = 'gardakota-v1';
const CACHE_ASSETS = [
    '/',
    '/index.html',
    '/css/style.css',
    '/modul/loader.js',
    '/manifest.json'
];

// Install Event: Pre-cache essential assets
self.addEventListener('install', event => {
    console.log('🔧 Service Worker: Installing...');

    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => {
                console.log('📦 Caching assets...');
                return cache.addAll(CACHE_ASSETS);
            })
            .then(() => {
                console.log('✅ Assets cached successfully');
            })
            .catch(error => {
                console.error('❌ Cache failed:', error);
            })
    );

    self.skipWaiting();
});

// Activate Event: Clean up old caches
self.addEventListener('activate', event => {
    console.log('✅ Service Worker: Activating...');

    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cacheName !== CACHE_NAME) {
                        console.log('🗑️ Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );

    self.clients.claim();
});

// Fetch Event: Network first, fallback to cache
self.addEventListener('fetch', event => {
    // Skip non-GET requests
    if (event.request.method !== 'GET') {
        return;
    }

    event.respondWith(
        fetch(event.request)
            .then(response => {
                // Clone response before caching
                const responseClone = response.clone();

                // Update cache with fresh content
                caches.open(CACHE_NAME).then(cache => {
                    cache.put(event.request, responseClone);
                });

                return response;
            })
            .catch(() => {
                // Network failed, try cache
                return caches.match(event.request)
                    .then(cachedResponse => {
                        if (cachedResponse) {
                            console.log('📦 Serving from cache:', event.request.url);
                            return cachedResponse;
                        }

                        // No cache available
                        return new Response('Offline - Content not available', {
                            status: 503,
                            statusText: 'Service Unavailable',
                            headers: new Headers({
                                'Content-Type': 'text/plain'
                            })
                        });
                    });
            })
    );
});

console.log('✅ Service Worker loaded');