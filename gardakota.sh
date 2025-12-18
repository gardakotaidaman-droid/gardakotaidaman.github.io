#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
WA_CAMAT="6285172206884"
IMG_LOGO="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png"

echo "🚀 MEMULAI RESTORASI TOTAL DASHBOARD, PETA, DAN AKSI..."

# 1. PASTIKAN SEMUA FOLDER ADA
mkdir -p modul/peta modul/aksi css

# 2. UPDATE DASHBOARD UTAMA (index.html) - FIX BMKG & PENGUMUMAN
cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota</title>
</head>
<body>
    <div id="alert-cuaca" style="display:none; background:#d32f2f; color:white; padding:10px; font-weight:bold; font-size:12px; border-bottom:3px solid yellow;">
        <marquee id="msg-cuaca">⚠️ WASPADA: Memeriksa Peringatan Dini BMKG...</marquee>
    </div>

    <div class="app-header">
        <img src="$IMG_LOGO" width="35">
        <h1>GARDA DUMAI KOTA</h1>
        <a href="modul/admin/login.html" style="color:var(--dark); font-size:20px;"><i class="fas fa-user-shield"></i></a>
    </div>

    <div class="container">
        <div class="card" style="background: linear-gradient(135deg, #002171, #0d47a1); color: white;">
            <div style="font-size:11px; text-transform:uppercase; opacity:0.8; font-weight:bold; margin-bottom:5px;">Pengumuman Masyarakat</div>
            <div id="msg-pengumuman" style="font-size:14px; font-weight:600; line-height:1.4;">
                📢 Selamat datang di layanan GARDA DUMAI KOTA. Gunakan tombol SOS jika dalam keadaan darurat!
            </div>
        </div>

        <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 15px;">
             <div class="card" style="margin:0; border-left:4px solid #ef6c00;">
                <small style="color:#ef6c00; font-weight:bold; font-size:10px;">INFO GEMPA</small>
                <h3 id="g-mag" style="margin:5px 0 0 0; font-size:18px;">--</h3>
                <div id="g-loc" style="font-size:9px; color:#666; overflow:hidden; white-space:nowrap;">Memuat...</div>
            </div>
             <div class="card" style="margin:0; border-left:4px solid #0066FF;">
                <small style="color:#0066FF; font-weight:bold; font-size:10px;">CUACA DUMAI</small>
                <h3 id="w-temp" style="margin:5px 0 0 0; font-size:18px;">--°C</h3>
                <div id="w-desc" style="font-size:9px; color:#666;">Memuat...</div>
            </div>
        </div>

        <a href="modul/aksi/index.html" class="btn-main" style="background:#d32f2f; box-shadow: 0 4px 15px rgba(211,47,47,0.4); margin-bottom:15px;">
            <i class="fas fa-bolt" style="margin-right:10px;"></i> SOS & DARURAT
        </a>
        
        <div class="card">
            <h4 style="margin:0 0 10px 0; font-size:14px; color:var(--dark);">SITUASI SAAT INI</h4>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <span style="font-size:12px; color:#666;">Laporan Diproses</span>
                <b id="st-proses" style="color:#ef6c00;">0</b>
            </div>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:5px;">
                <span style="font-size:12px; color:#666;">Laporan Selesai</span>
                <b id="st-selesai" style="color:#2e7d32;">0</b>
            </div>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house"></i></a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i></a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i></a>
        <a href="modul/operator/index.html" class="nav-item"><i class="fas fa-plus-circle" style="font-size:24px; color:var(--primary);"></i></a>
    </nav>

    <script>
        const SAKTI = "$URL_SAKTI";
        async function fetchBMKG() {
            try {
                // Gempa
                const gRes = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
                const g = (await gRes.json()).Infogempa.gempa;
                document.getElementById('g-mag').innerText = g.Magnitude + " SR";
                document.getElementById('g-loc').innerText = g.Wilayah;

                // Cuaca Dumai Kota
                const wRes = await fetch('https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=14.72.06.1001');
                const w = (await wRes.json()).data[0].cuaca[0][0];
                document.getElementById('w-temp').innerText = w.t + "°C";
                document.getElementById('w-desc').innerText = w.weather_desc;

                // Stats & Pengumuman
                const sRes = await fetch(SAKTI);
                const s = await sRes.json();
                document.getElementById('st-proses').innerText = s.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
                document.getElementById('st-selesai').innerText = s.laporan.filter(i => i[6] === 'Selesai').length;
                if(s.info[0]) document.getElementById('msg-pengumuman').innerText = s.info[0][1];
            } catch(e) {}
        }
        fetchBMKG(); setInterval(fetchBMKG, 60000);
    </script>
</body>
</html>
EOF

# 3. RESTORASI MODUL AKSI (FIX 404)
cat << EOF > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>SOS Darurat</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:var(--dark);"><i class="fas fa-arrow-left"></i></a>
        <h1>AKSI DARURAT</h1>
        <div style="width:20px;"></div>
    </div>
    <div class="container" style="text-align:center;">
        <div class="card" style="padding:40px 20px;">
            <div onclick="callSOS()" style="width:140px; height:140px; background:radial-gradient(#ff5252, #b71c1c); border-radius:50%; margin:auto; display:flex; align-items:center; justify-content:center; color:white; font-size:32px; font-weight:900; box-shadow:0 10px 30px rgba(183,28,28,0.5); border:8px solid rgba(255,255,255,0.2); cursor:pointer;">SOS</div>
            <p style="margin-top:20px; font-weight:bold; color:#b71c1c;">TEKAN UNTUK SITUASI DARURAT</p>
        </div>
        
        <div class="card">
            <h4 style="margin-bottom:15px;">HUBUNGI PETUGAS</h4>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                <a href="tel:112" class="btn-main" style="background:#b71c1c; font-size:12px;">📞 BPBD/112</a>
                <a href="https://wa.me/$WA_CAMAT" class="btn-main" style="background:#2e7d32; font-size:12px;">🟢 WA CAMAT</a>
            </div>
        </div>
    </div>
    <script>
        function callSOS() {
            if(confirm("Kirim sinyal SOS ke Command Center?")) {
                window.location.href = "https://wa.me/$WA_CAMAT?text=🚨 *SINYAL SOS DARURAT!*%0AMohon bantuan segera ke lokasi saya!";
            }
        }
    </script>
</body>
</html>
EOF

# 4. RESTORASI MODUL PETA (FIX 404 & LAYERS)
cat << EOF > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <title>Peta Sebaran</title>
    <style>#map { width:100%; height:calc(100vh - 130px); }</style>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:var(--dark);"><i class="fas fa-arrow-left"></i></a>
        <h1>PETA SITUASI</h1>
        <div style="width:20px;"></div>
    </div>
    <div id="map"></div>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        const map = L.map('map').setView([1.67, 101.45], 13);
        const osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        const sat = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}');
        
        const base = { "Peta Jalan": osm, "Satelit": sat };
        L.control.layers(base).addTo(map);

        async function load() {
            const r = await fetch("$URL_SAKTI");
            const d = await r.json();
            d.laporan.forEach(i => {
                const m = i[4].match(/query=(-?\\d+\\.\\d+),(-?\\d+\\.\\d+)/);
                if(m) L.marker([m[1], m[2]]).addTo(map).bindPopup(\`<b>\${i[1]}</b><br>\${i[2]}<br><small>\${i[6]}</small>\`);
            });
        }
        load();
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ RESTORASI SELESAI"
echo "📍 Dashboard: Gempa, Cuaca, Pengumuman AKTIF."
echo "📍 Modul Aksi & Peta: FIXED (Tidak 404)."
echo "-------------------------------------------------------"