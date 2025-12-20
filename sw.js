const CACHE_NAME = 'garda-dk-v1';
const assetsToCache = [
  '/',
  '/index.html',
  '/css/style.css',
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css',
  'https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png'
];

// 1. Install & Cache
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(assetsToCache);
    })
  );
  self.skipWaiting();
});

// 2. Activate & Clean
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key)));
    })
  );
  self.clients.claim();
});

// 3. Fetch (Network First)
self.addEventListener('fetch', event => {
  // Hanya proses request GET
  if (event.request.method !== 'GET') return;

  event.respondWith(
    fetch(event.request).then(response => {
      // Jika sukses, clone response-nya
      const responseToCache = response.clone();
      // Buka cache dan simpan versi terbaru
      caches.open(CACHE_NAME).then(cache => {
        cache.put(event.request, responseToCache);
      });
      // Return response asli
      return response;
    }).catch(() => {
      // Jika fetch gagal (offline), cari di cache
      return caches.match(event.request);
    })
  );
});
