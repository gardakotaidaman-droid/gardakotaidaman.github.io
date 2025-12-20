// Service Worker - Command Center Garda Dumai Kota
// Version: 1.0

const CACHE_VERSION = 'gardakota-cc-v1';
const CACHE_NAMES = {
  CORE: `${CACHE_VERSION}-core`,
  ASSETS: `${CACHE_VERSION}-assets`,
};

const CORE_ASSETS = [
  '/',
  '/index.html',
  '/css/style.css',
  '/manifest.json'
];

// Install: cache file inti
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAMES.CORE)
      .then(cache => cache.addAll(CORE_ASSETS))
      .catch(err => console.warn('Cache core gagal:', err))
  );
  self.skipWaiting();
});

// Activate: bersihkan cache lama
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then(names => {
      return Promise.all(
        names.map(name => {
          if (!Object.values(CACHE_NAMES).includes(name)) {
            return caches.delete(name);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// Fetch: strategi berbeda untuk lokal vs API eksternal
self.addEventListener('fetch', (event) => {
  const req = event.request;
  const url = new URL(req.url);

  // Hanya GET yang di-handle
  if (req.method !== 'GET') return;

  // API eksternal (BMKG, Google Script, OSM/Nominatim) -> selalu network first
  if (
    url.hostname.includes('bmkg.go.id') ||
    url.hostname.includes('google.com') ||
    url.hostname.includes('googleapis.com') ||
    url.hostname.includes('openstreetmap.org') ||
    url.hostname.includes('tile.') ||
    url.hostname.includes('nominatim') ||
    url.hostname.includes('cdnjs.cloudflare.com')
  ) {
    event.respondWith(fetch(req).catch(() => caches.match(req)));
    return;
  }

  // Aset lokal (HTML, CSS, img) -> network first fallback cache
  if (url.origin === location.origin) {
    event.respondWith(
      fetch(req)
        .then((res) => {
          const resClone = res.clone();
          caches.open(CACHE_NAMES.ASSETS).then(cache => cache.put(req, resClone));
          return res;
        })
        .catch(() => caches.match(req).then(cached => {
          if (cached) return cached;
          if (req.destination === 'document') {
            return caches.match('/index.html');
          }
          return new Response('Offline', { status: 503 });
        }))
    );
  }
});

console.log('✅ Service Worker Command Center loaded');
