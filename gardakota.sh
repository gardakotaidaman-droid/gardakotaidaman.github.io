#!/bin/bash

# CONFIG DATA - INTEGRASI URL SAKTI BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
WA_CAMAT="6285172206884"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "💎 MEMBANGUN EKOSISTEM GARDA DUMAI KOTA - FULL MODULES..."

# 1. REBUILD STRUKTUR FOLDER
rm -rf css js modul assets
mkdir -p css js modul/admin modul/aksi modul/operator modul/peta assets/img

# 2. GLOBAL CSS (Biru Tua Midnight)
cat << 'EOF' > css/style.css
:root { --primary: #0d47a1; --primary-dark: #002171; --accent: #d32f2f; --bg: #f4f7f6; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 90px; color: #1a237e; }
.app-header { background: linear-gradient(135deg, var(--primary-dark), var(--primary)); color: white; padding: 25px 15px; border-radius: 0 0 25px 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 15px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 1000; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 18px; padding: 18px; margin-bottom: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); border: 1px solid rgba(13,71,161,0.1); }
.btn-main { background: linear-gradient(to right, var(--primary), var(--primary-dark)); color: white; border: none; padding: 15px; border-radius: 12px; width: 100%; font-weight: bold; cursor: pointer; text-align: center; display: block; text-decoration: none; box-sizing: border-box; font-size: 16px; margin-top: 10px; }
.bottom-nav { position: fixed; bottom: 15px; left: 15px; right: 15px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); display: flex; padding: 12px 0; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); z-index: 1000; border: 1px solid rgba(255,255,255,0.3); }
.nav-item { flex: 1; text-align: center; font-size: 10px; color: #999; text-decoration: none; }
.nav-item i { font-size: 22px; display: block; margin-bottom: 4px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; box-sizing: border-box; }
.badge { padding: 4px 8px; border-radius: 6px; font-size: 10px; color: white; font-weight: bold; text-transform: uppercase; }
.b-masuk { background: #9e9e9e; } .b-verifikasi { background: #0288d1; } .b-penanganan { background: #ff9800; } .b-selesai { background: #388e3c; }
EOF

# 3. MODUL ADMIN: COMMAND CENTER
cat << EOF > modul/admin/admin.js
const SAKTI = "$URL_SAKTI";
if(localStorage.getItem("role") !== "admin") window.location.href="login.html";

async function loadAdmin() {
    const r = await fetch(SAKTI);
    const d = await r.json();
    let logH = "";
    d.logs.reverse().slice(0,10).forEach(l => {
        logH += \`<div style="font-size:11px; padding:5px; border-bottom:1px solid #eee;">[\${new Date(l[0]).toLocaleTimeString()}] \${l[1]} \${l[2]}</div>\`;
    });
    document.getElementById('log-list').innerHTML = logH;

    let html = "";
    d.laporan.reverse().forEach((i, idx) => {
        if(idx === d.laporan.length - 1 || !i[0]) return;
        html += \`<div class="card" style="border-left:5px solid var(--primary);">
            <div style="display:flex; justify-content:space-between;">
                <small><b>\${i[1]}</b> | \${i[6]}</small>
                <span class="badge b-\${i[6].toLowerCase()}">\${i[6]}</span>
            </div>
            <p style="font-size:13px; margin:10px 0;">\${i[3]}</p>
            <div style="display:flex; gap:5px;">
                <button class="btn-main" style="padding:5px; font-size:10px; background:#0288d1; flex:1;" onclick="upd('\${i[0]}','Verifikasi')">VERIF</button>
                <button class="btn-main" style="padding:5px; font-size:10px; background:#ff9800; flex:1;" onclick="upd('\${i[0]}','Penanganan')">TANGANI</button>
                <button class="btn-main" style="padding:5px; font-size:10px; background:#388e3c; flex:1;" onclick="upd('\${i[0]}','Selesai')">DONE</button>
            </div>
        </div>\`;
    });
    document.getElementById('wf-list').innerHTML = html;
}
async function upd(ts, st) {
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:ts, status:st }) });
    alert("Berhasil!"); location.reload();
}
loadAdmin();
EOF

cat << 'EOF' > modul/admin/index.html
<!DOCTYPE html>
<html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><title>Admin</title></head><body>
    <div class="app-header"><div style="font-weight:bold;">COMMAND CENTER</div><i class="fas fa-power-off" onclick="localStorage.clear(); location.href='login.html'"></i></div>
    <div class="container"><div class="card"><h4>Log Aktivitas</h4><div id="log-list">Memuat...</div></div><div id="wf-list"></div></div><script src="admin.js"></script></body></html>
EOF

cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id"><head><meta charset="UTF-8"><link rel="stylesheet" href="../../css/style.css"><title>Login</title></head>
<body style="background:#002171; display:flex; align-items:center; height:100vh;">
    <div class="container"><div class="card" style="text-align:center;"><h3>LOGIN GARDA</h3><input type="text" id="u" placeholder="User"><input type="password" id="p" placeholder="Pass"><button class="btn-main" onclick="auth()">MASUK</button></div></div>
    <script>
        function auth() {
            const u = document.getElementById('u').value; const p = document.getElementById('p').value;
            if(u === "camat" && p === "dksiaga") { localStorage.setItem("role","admin"); localStorage.setItem("user_label","CAMAT"); location.href="index.html"; }
            else if(p === "pantaudk") { localStorage.setItem("role","operator"); localStorage.setItem("user_label",u.toUpperCase()); location.href="../operator/index.html"; }
            else alert("Salah!");
        }
    </script></body></html>
EOF

# 4. MODUL OPERATOR: LAPORAN LENGKAP + GPS
cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI"; const IMGBB = "$IMGBB_KEY"; const user = localStorage.getItem("user_label");
document.getElementById('op-name').innerText = user;
let lat="", lng="";
function track() {
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        document.getElementById('gps-msg').innerHTML = "✅ KOORDINAT TERKUNCI";
        fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action: "log", user: user, type: "Kunci GPS" }) });
    });
}
async function lapor() {
    const file = document.getElementById('foto').files[0];
    if(!file || !lat) return alert("Foto & GPS Wajib!");
    document.getElementById('btnL').innerText = "Mengirim...";
    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ nama:user, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:"http://googleusercontent.com/maps.google.com/q="+lat+","+lng, foto:dI.data.url }) });
    alert("Berhasil!"); location.reload();
}
EOF

cat << 'EOF' > modul/operator/index.html
<!DOCTYPE html>
<html lang="id"><head><meta charset="UTF-8"><link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></head><body>
    <div class="app-header"><div>OPERATOR LAPOR</div><i class="fas fa-sign-out-alt" onclick="location.href='../admin/login.html'"></i></div>
    <div class="container">
        <div class="card"><b>Petugas:</b> <span id="op-name"></span></div>
        <div class="card">
            <button class="btn-main" onclick="track()">KUNCI GPS</button><p id="gps-msg" style="text-align:center; font-size:11px;">Belum dikunci</p>
            <select id="kat">
                <option>🌊 Banjir Rob</option><option>🗑️ Sampah</option><option>👮 Kamtibmas</option><option>🔥 Kebakaran</option>
                <option>💡 Lampu Jalan</option><option>🛣️ Jalan Rusak</option><option>🌳 Pohon Tumbang</option>
            </select>
            <textarea id="ket" placeholder="Keterangan..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnL" onclick="lapor()">KIRIM LAPORAN</button>
        </div>
    </div><script src="operator.js"></script></body></html>
EOF

# 5. MODUL PETA & AKSI (FINAL)
cat << EOF > modul/peta/peta.js
var map = L.map('map').setView([1.680, 101.448], 14);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
async function load() {
    const r = await fetch("$URL_SAKTI"); const d = await r.json();
    d.laporan.reverse().forEach((i, idx) => {
        if(!i[4]) return; const c = i[4].match(/q=(-?\d+\.\d+),(-?\d+\.\d+)/);
        if(c) L.circleMarker([c[1], c[2]], {color: i[6]=='Selesai'?'green':'red'}).addTo(map).bindPopup(\`<b>\${i[1]}</b><br>\${i[3]}\`);
    });
}
load();
EOF

cat << 'EOF' > modul/peta/index.html
<!DOCTYPE html>
<html lang="id"><head><meta charset="UTF-8"><link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"><title>Peta</title></head><body>
    <div class="app-header"><a href="../../index.html" style="color:white;"><i class="fas fa-home"></i></a><div>PETA SEBARAN</div><div></div></div>
    <div id="map" style="height:calc(100vh - 135px);"></div>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script><script src="peta.js"></script></body></html>
EOF

# 6. MODUL AKSI (SOS)
cat << EOF > modul/aksi/aksi.js
function sos() {
    navigator.geolocation.getCurrentPosition(p => {
        const maps = "http://googleusercontent.com/maps.google.com/q=" + p.coords.latitude + "," + p.coords.longitude;
        window.location.href = "https://wa.me/$WA_CAMAT?text=*🚨 SOS DARURAT!* Lokasi: " + maps;
    });
}
EOF

cat << 'EOF' > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id"><head><meta charset="UTF-8"><link rel="stylesheet" href="../../css/style.css"><title>Aksi</title></head><body>
    <div class="app-header"><a href="../../index.html" style="color:white;">Kembali</a><div>AKSI DARURAT</div><div></div></div>
    <div class="container"><div class="card" style="text-align:center;"><button onclick="sos()" style="background:red; color:white; border-radius:50%; width:100px; height:100px; border:none; font-weight:bold;">SOS</button></div>
    <div class="card"><div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
        <a href="tel:110" class="btn-main">POLISI</a><a href="tel:076538208" class="btn-main">DAMKAR</a>
    </div></div></div><script src="aksi.js"></script></body></html>
EOF

# 7. INDEX UTAMA
cat << EOF > index.html
<!DOCTYPE html>
<html lang="id"><head><meta charset="UTF-8"><link rel="stylesheet" href="css/style.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><title>Garda Dumai Kota</title></head><body>
    <div style="background:#ffeb3b; color:red; padding:5px;"><marquee>⚠️ SIAGA BANJIR ROB RIAU</marquee></div>
    <div class="app-header"><img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png" style="width:40px;"><div>GARDA DUMAI KOTA</div><i class="fas fa-bell"></i></div>
    <div class="container"><div class="card" style="border-left:5px solid red;"><b>BMKG:</b> <span id="g">Memuat...</span></div>
    <div style="display:flex; gap:10px;"><div class="card" style="flex:1; text-align:center;"><h2 id="p">0</h2>PROSES</div><div class="card" style="flex:1; text-align:center;"><h2 id="s">0</h2>DONE</div></div>
    <a href="modul/aksi/index.html" class="btn-main">DARURAT & SOS</a></div>
    <nav class="bottom-nav"><a href="index.html" class="nav-item active"><i class="fas fa-home"></i>Home</a><a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map"></i>Peta</a><a href="modul/admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Admin</a></nav>
    <script>
        async function load() {
            const r = await fetch("$URL_SAKTI"); const d = await r.json();
            document.getElementById('p').innerText = d.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
            document.getElementById('s').innerText = d.laporan.filter(i => i[6] === 'Selesai').length;
            const g = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'); const gd = await g.json();
            document.getElementById('g').innerText = gd.Infogempa.gempa.Magnitude + " SR - " + gd.Infogempa.gempa.Wilayah;
        } load();
    </script></body></html>
EOF

echo "------------------------------------------------------------"
echo "🌟 GARDA DUMAI KOTA PARIPURNA - SEMUA MODUL SIAP!"
echo "📍 LOGIN ADMIN: camat / dksiaga"
echo "📍 LOGIN OPERATOR: Nama Lurah / pantaudk"
echo "------------------------------------------------------------"