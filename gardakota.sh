#!/bin/bash

echo "🚀 Membangun Seluruh Modul GARDA DUMAI KOTA..."

# 1. Folder Utama
mkdir -p css assets/img modul/aksi modul/peta modul/admin

# 2. CSS GLOBAL (style.css)
cat << 'EOF' > css/style.css
:root { --primary: #2e7d32; --accent: #d32f2f; --bg: #f4f7f6; --white: #ffffff; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 70px; }
.app-bar { background: var(--primary); color: white; padding: 15px; text-align: center; font-weight: bold; position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: var(--white); border-radius: 12px; padding: 15px; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
input, textarea, select { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
.btn { background: var(--primary); color: white; border: none; padding: 15px; border-radius: 30px; width: 100%; font-weight: bold; cursor: pointer; display: block; text-align: center; text-decoration: none; }
.bottom-nav { position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #eee; padding: 10px 0; z-index: 1000; }
.nav-item { flex: 1; text-align: center; font-size: 11px; color: #888; text-decoration: none; }
.nav-item.active { color: var(--primary); font-weight: bold; }
EOF

# 3. PWA & SERVICE WORKER
cat << 'EOF' > manifest.json
{
  "name": "GARDA DUMAI KOTA",
  "short_name": "GardaKota",
  "start_url": "/index.html",
  "display": "standalone",
  "background_color": "#2e7d32",
  "theme_color": "#2e7d32",
  "icons": [{ "src": "assets/img/garda-dumaikota.png", "sizes": "512x512", "type": "image/png" }]
}
EOF

cat << 'EOF' > sw.js
const CACHE = 'garda-v1';
self.addEventListener('install', e => e.waitUntil(caches.open(CACHE).then(c => c.addAll(['/', '/index.html', '/css/style.css']))));
self.addEventListener('fetch', e => e.respondWith(caches.match(e.request).then(r => r || fetch(e.request))));
EOF

# 4. LANDING PAGE (index.html)
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Garda Dumai Kota</title><link rel="stylesheet" href="css/style.css"><link rel="manifest" href="manifest.json">
</head>
<body>
    <div class="app-bar">🛡️ GARDA DUMAI KOTA</div>
    <div class="container">
        <div class="card" style="background: linear-gradient(135deg, #1e3c72, #2a5298); color:white;">
            <small>Cuaca Dumai Kota</small><h3 id="txt-cuaca">29°C - Berawan</h3>
        </div>
        <div style="display:flex; gap:10px;">
            <div class="card" style="flex:1; text-align:center;"><h2 style="color:#f39c12; margin:0" id="st-proses">0</h2><small>PROSES</small></div>
            <div class="card" style="flex:1; text-align:center;"><h2 style="color:#2ecc71; margin:0" id="st-selesai">0</h2><small>SELESAI</small></div>
        </div>
        <a href="modul/aksi/index.html" class="btn">📝 LAPOR SEKARANG</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active">🏠<br>Home</a>
        <a href="modul/peta/index.html" class="nav-item">📍<br>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item">⚡<br>Aksi</a>
        <a href="modul/admin/login.html" class="nav-item">👤<br>Admin</a>
    </nav>
    <script> if ('serviceWorker' in navigator) navigator.serviceWorker.register('/sw.js'); </script>
</body>
</html>
EOF

# 5. MODUL AKSI (Lapor & Darurat)
cat << 'EOF' > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><title>Aksi - Garda Kota</title>
</head>
<body>
    <div class="app-bar">⚡ AKSI CEPAT</div>
    <div class="container">
        <div class="card">
            <h3>📝 Form Lapor</h3>
            <input type="text" id="nama" placeholder="Nama Pelapor">
            <select id="kat"><option>Jalan Rusak</option><option>Sampah</option><option>Banjir</option></select>
            <textarea id="ket" placeholder="Keterangan kejadian"></textarea>
            <button onclick="ambilGPS()" class="btn" style="background:#007bff; margin-bottom:10px;">📍 Ambil GPS</button>
            <div id="gps-info" style="font-size:11px; margin-bottom:10px;">Lokasi belum diambil</div>
            <input type="file" id="foto" accept="image/*">
            <button id="btnKirim" class="btn" style="margin-top:15px;" onclick="kirimLaporan()">🚀 KIRIM LAPORAN</button>
        </div>
        <div class="card" style="background:#ffebee">
            <h3>🚨 Hubungi Petugas</h3>
            <a href="tel:110" class="btn" style="background:#b71c1c; margin-bottom:10px;">🚓 POLISI (110)</a>
            <a href="tel:076538208" class="btn" style="background:#e65100;">🚒 DAMKAR</a>
        </div>
    </div>
    <script>
        let lat="", lng="";
        function ambilGPS() {
            navigator.geolocation.getCurrentPosition(p => {
                lat=p.coords.latitude; lng=p.coords.longitude;
                document.getElementById('gps-info').innerText = "✅ Lokasi Terkunci: " + lat + "," + lng;
            });
        }
        async function kirimLaporan() {
            const nama = document.getElementById('nama').value;
            const file = document.getElementById('foto').files[0];
            if(!nama || !file || !lat) return alert("Lengkapi data!");
            
            document.getElementById('btnKirim').innerText = "⌛ Mengirim...";
            // Logika upload ImgBB & WA Admin ditaruh di sini
            alert("Laporan berhasil (Dummy)! Hubungkan SCRIPT_URL Google Sheets Bapak.");
        }
    </script>
</body>
</html>
EOF

# 6. MODUL PETA (Peta Pantau)
cat << 'EOF' > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <title>Peta - Garda Kota</title>
</head>
<body>
    <div class="app-bar">📍 PETA PANTAU DUMAI KOTA</div>
    <div id="map" style="height: calc(100vh - 120px); width: 100%;"></div>
    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item">🏠<br>Home</a>
        <a href="index.html" class="nav-item active">📍<br>Peta</a>
        <a href="../aksi/index.html" class="nav-item">⚡<br>Aksi</a>
    </nav>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        var map = L.map('map').setView([1.680, 101.448], 14);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        // Tambahkan marker laporan dari database di sini
    </script>
</body>
</html>
EOF

# 7. MODUL ADMIN (Login & Dashboard)
cat << 'EOF' > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><title>Login Admin</title>
</head>
<body style="background:var(--primary); display:flex; align-items:center; height:100vh;">
    <div class="container">
        <div class="card" style="text-align:center;">
            <h3>🔑 LOGIN ADMIN</h3>
            <input type="text" id="user" placeholder="Username">
            <input type="password" id="pass" placeholder="Password">
            <button onclick="login()" class="btn">MASUK</button>
        </div>
    </div>
    <script>
        function login() {
            if(document.getElementById('user').value === "camat_dumkot" && document.getElementById('pass').value === "dumaiidaman2025") {
                localStorage.setItem("admin", "true"); window.location.href="index.html";
            } else alert("Salah!");
        }
    </script>
</body>
</html>
EOF

cat << 'EOF' > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><title>Admin Panel</title>
</head>
<body>
    <div class="app-bar">📊 DASHBOARD ADMIN</div>
    <div class="container">
        <button onclick="window.print()" class="btn" style="background:#455a64; margin-bottom:15px;">🖨️ CETAK LAPORAN MINGGUAN</button>
        <div class="card" style="overflow-x:auto;">
            <table style="width:100%; font-size:12px; border-collapse:collapse;">
                <thead><tr style="background:#eee;"><th>Tgl</th><th>Masalah</th><th>Status</th></tr></thead>
                <tbody id="data-table"><tr><td colspan="3" align="center">Memuat data...</td></tr></tbody>
            </table>
        </div>
    </div>
    <script>
        if(localStorage.getItem("admin") !== "true") window.location.href="login.html";
        // Fungsi fetch data dari Google Sheets ditaruh di sini
    </script>
</body>
</html>
EOF

echo "✅ SELESAI! Seluruh file modul telah terbuat secara otomatis."
echo "💡 Silakan buka folder project Bapak dan upload ke GitHub."