#!/bin/bash

# CONFIG DATA (Sesuai Thread)
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMG_LOGO="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"
WA_CAMAT="6285172206884"

echo "🧹 REBUILD TOTAL: GARDA DUMAI KOTA V3 (STABIL)..."

# 1. STRUKTUR FOLDER
rm -rf modul css
mkdir -p css modul/admin modul/aksi modul/operator modul/peta

# 2. MASTER CSS (KONSISTEN & MODERN)
cat << 'EOF' > css/style.css
:root { --primary: #0066FF; --dark: #001a4d; --bg: #f4f7f6; --h: 60px; --nav: 70px; }
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; font-family: 'Segoe UI', sans-serif; }
body { margin: 0; background: var(--bg); padding-top: var(--h); padding-bottom: var(--nav); }
.app-header { height: var(--h); background: var(--dark); color: white; display: flex; align-items: center; justify-content: space-between; padding: 0 15px; position: fixed; top: 0; width: 100%; z-index: 2000; box-shadow: 0 2px 10px rgba(0,0,0,0.2); }
.app-header h1 { font-size: 14px; margin: 0; font-weight: 800; text-transform: uppercase; flex: 1; text-align: center; }
.header-icon { width: 35px; color: white; text-decoration: none; font-size: 18px; display: flex; align-items: center; justify-content: center; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 12px; padding: 15px; margin-bottom: 15px; box-shadow: 0 3px 10px rgba(0,0,0,0.05); }
.btn-main { height: 48px; background: var(--primary); color: white; border: none; border-radius: 10px; width: 100%; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; text-decoration: none; font-size: 14px; }
.bottom-nav { height: var(--nav); position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #ddd; z-index: 2000; }
.nav-item { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #888; text-decoration: none; font-size: 10px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
.nav-item i { font-size: 20px; margin-bottom: 3px; }
input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #fafafa; }
EOF

# 3. DASHBOARD UTAMA (FIX BMKG & PENGUMUMAN)
cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota</title>
</head>
<body>
    <div class="app-header">
        <div class="header-icon"></div>
        <h1>GARDA DUMAI KOTA</h1>
        <a href="modul/admin/login.html" class="header-icon"><i class="fas fa-user-shield"></i></a>
    </div>
    <div class="container">
        <div class="card" style="background: var(--dark); color: white; text-align: center;">
            <img src="$IMG_LOGO" width="60">
            <div id="msg-info" style="font-size: 13px; margin-top: 10px;">Memuat informasi...</div>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
            <div class="card" style="margin:0;"><small>MAGNITUDE</small><h3 id="g-mag" style="margin:5px 0;">--</h3><div id="g-loc" style="font-size:9px;">...</div></div>
            <div class="card" style="margin:0;"><small>SUHU</small><h3 id="w-temp" style="margin:5px 0;">--°C</h3><div id="w-desc" style="font-size:9px;">...</div></div>
        </div>
        <a href="modul/aksi/index.html" class="btn-main" style="background: #d32f2f; margin-top: 15px;"><i class="fas fa-bolt"></i>&nbsp; SOS DARURAT</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="modul/operator/index.html" class="nav-item"><i class="fas fa-plus-circle"></i>Lapor</a>
    </nav>
    <script>
        async function load() {
            try {
                const g = await (await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json')).json();
                document.getElementById('g-mag').innerText = g.Infogempa.gempa.Magnitude + " SR";
                document.getElementById('g-loc').innerText = g.Infogempa.gempa.Wilayah;
                const w = await (await fetch('https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=14.72.06.1001')).json();
                document.getElementById('w-temp').innerText = w.data[0].cuaca[0][0].t + "°C";
                document.getElementById('w-desc').innerText = w.data[0].cuaca[0][0].weather_desc;
                const s = await (await fetch("$URL_SAKTI")).json();
                document.getElementById('msg-info').innerText = s.info[0][1];
            } catch(e) {}
        }
        load();
    </script>
</body>
</html>
EOF

# 4. MODUL LOGIN (HIRARKI INSTRUKSI)
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <title>Login Petugas</title>
</head>
<body style="display:flex; align-items:center; justify-content:center; height:100vh;">
    <div class="card" style="width:340px; text-align:center;">
        <img src="$IMG_LOGO" width="70">
        <h3>LOGIN PETUGAS</h3>
        <input type="text" id="user" placeholder="Username">
        <input type="password" id="pass" placeholder="Password">
        <button class="btn-main" onclick="auth()">MASUK</button>
    </div>
    <script>
        function auth() {
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;
            const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil"];
            const kels = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
            const roles = ["lurah", "babinsa", "bhabin"];
            let role = "", label = "";
            if(admins.includes(u) && p === "dksiaga") { role="admin"; label=u.toUpperCase(); }
            else {
                kels.forEach(k => roles.forEach(r => {
                    if(u === \`\${r}-\${k}\` && p === "pantaudk") { role="operator"; label=u.toUpperCase().replace("-"," "); }
                }));
            }
            if(role) {
                localStorage.setItem("role", role); localStorage.setItem("user_label", label);
                window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
            } else alert("Akses Ditolak!");
        }
    </script>
</body>
</html>
EOF

# 5. MODUL OPERATOR (LENGKAP: 11 KATEGORI + GPS FIX)
cat << EOF > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Lapor</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-icon"><i class="fas fa-home"></i></a>
        <h1>LAPOR KEJADIAN</h1>
        <div class="header-icon"></div>
    </div>
    <div class="container">
        <div class="card" style="background:#e3f2fd; border-left:5px solid #0066FF;">
            <small>Petugas:</small> <b id="op-name">-</b>
        </div>
        <div class="card">
            <div id="gps-box" style="padding:15px; background:#eee; text-align:center; border-radius:10px; font-size:12px; font-weight:bold;">📍 Lokasi Belum Dikunci</div>
            <button class="btn-main" onclick="trackGPS()" style="background:#333; height:40px; margin-top:10px;">KUNCI GPS</button>
            <hr>
            <select id="kat">
                <option>🌊 Banjir Rob / Pasang Keling</option>
                <option>🕳️ Drainase Tersumbat / Banjir</option>
                <option>🗑️ Penumpukan Sampah</option>
                <option>👮 Kamtibmas / Tawuran</option>
                <option>🔥 Kebakaran Lahan / Karhutla</option>
                <option>💡 Lampu Jalan Mati (PJU)</option>
                <option>🛣️ Infrastruktur / Jalan Rusak</option>
                <option>🌳 Pohon Tumbang / Kabel</option>
                <option>🏪 Penertiban PKL / Perda</option>
                <option>📄 Layanan Publik / Administrasi</option>
                <option>❓ Lainnya</option>
            </select>
            <textarea id="ket" placeholder="Keterangan kejadian..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnKirim" onclick="kirimLapor()" style="margin-top:15px;">🚀 KIRIM LAPORAN</button>
        </div>
    </div>
    <script>
        let lat="", lng="";
        document.getElementById('op-name').innerText = localStorage.getItem("user_label") || "Petugas";
        function trackGPS() {
            navigator.geolocation.getCurrentPosition(p => {
                lat = p.coords.latitude; lng = p.coords.longitude;
                document.getElementById('gps-box').innerHTML = "✅ GPS TERKUNCI";
                document.getElementById('gps-box').style.background = "#e8f5e9";
            }, () => alert("Aktifkan GPS!"));
        }
        async function kirimLapor() {
            const file = document.getElementById('foto').files[0];
            if(!lat || !file) return alert("GPS & Foto Wajib!");
            document.getElementById('btnKirim').innerText = "⌛ Mengirim...";
            let fd = new FormData(); fd.append("image", file);
            let rI = await fetch("https://api.imgbb.com/1/upload?key=$IMGBB_KEY", {method:"POST", body:fd});
            let dI = await rI.json();
            await fetch("$URL_SAKTI", { method:'POST', mode:'no-cors', body: JSON.stringify({ nama: localStorage.getItem("user_label"), kategori: document.getElementById('kat').value, keterangan: document.getElementById('ket').value, lokasi: "http://maps.google.com/maps?q="+lat+","+lng, foto: dI.data.url }) });
            alert("Laporan Terkirim!"); location.reload();
        }
    </script>
</body>
</html>
EOF

# 6. MODUL AKSI & PETA (ANTI 404)
cat << EOF > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id"><head><link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></head>
<body><div class="app-header"><a href="../../index.html" class="header-icon"><i class="fas fa-home"></i></a><h1>DARURAT</h1><div class="header-icon"></div></div>
<div class="container" style="text-align:center;"><div class="card"><a href="tel:112" class="btn-main" style="background:#d32f2f; height:80px; font-size:24px;">PANGGIL 112</a></div></div></body></html>
EOF

cat << EOF > modul/peta/index.html
<!DOCTYPE html>
<html lang="id"><head><link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/></head>
<body><div class="app-header"><a href="../../index.html" class="header-icon"><i class="fas fa-home"></i></a><h1>PETA SITUASI</h1><div class="header-icon"></div></div>
<div id="map" style="width:100%; height:calc(100vh - 130px);"></div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    const map = L.map('map').setView([1.67, 101.45], 13);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
</script></body></html>
EOF

echo "✅ REBUILD SUKSES. Silakan cek https://gardakota.vercel.app"