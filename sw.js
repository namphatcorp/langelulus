/* L'Angelulus — Service Worker (PWA)
   · Trang (HTML): mạng trước, mất mạng → bản index.html đã lưu (SPA nên mọi đường dẫn dùng chung 1 file).
   · /assets/ (ảnh, logo): trả bản đã lưu ngay + tải lại ngầm để lần sau có bản mới.
   · Tên miền khác (Google Fonts, GA4, Apps Script đăng ký thành viên…): KHÔNG can thiệp.
   Đổi VERSION khi muốn xoá sạch bộ nhớ đệm cũ của khách. */
const VERSION = 'v1';
const PAGE_CACHE = 'la-page-' + VERSION;
const ASSET_CACHE = 'la-asset-' + VERSION;
const ASSET_MAX = 250;
const PRECACHE = ['/', '/index.html', '/manifest.webmanifest',
  '/assets/app/icon-192.png', '/assets/brand/logo-mark-light.png', '/assets/brand/logo-word-light.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(PAGE_CACHE).then(c => c.addAll(PRECACHE)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys()
    .then(keys => Promise.all(keys.filter(k => k !== PAGE_CACHE && k !== ASSET_CACHE).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

async function trim(cache){
  const keys = await cache.keys();
  for(let i = 0; i < keys.length - ASSET_MAX; i++) await cache.delete(keys[i]);
}

self.addEventListener('fetch', e => {
  const req = e.request;
  if(req.method !== 'GET') return;
  const url = new URL(req.url);
  if(url.origin !== location.origin) return;

  if(req.mode === 'navigate'){
    e.respondWith((async () => {
      try{
        const res = await fetch(req);
        if(res.ok){ const c = await caches.open(PAGE_CACHE); c.put('/index.html', res.clone()); }
        return res;
      }catch(err){
        return (await caches.match('/index.html')) || (await caches.match('/')) || Response.error();
      }
    })());
    return;
  }

  if(url.pathname.indexOf('/assets/') === 0){
    e.respondWith((async () => {
      const c = await caches.open(ASSET_CACHE);
      const hit = await c.match(req);
      const net = fetch(req).then(res => {
        if(res.ok && res.type === 'basic'){ c.put(req, res.clone()).then(() => trim(c)); }
        return res;
      }).catch(() => null);
      if(hit){ e.waitUntil(net); return hit; }
      return (await net) || Response.error();
    })());
  }
});
