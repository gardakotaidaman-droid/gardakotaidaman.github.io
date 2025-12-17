#!/bin/bash

# CONFIG DATA - INTEGRASI URL SAKTI BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
WA_CAMAT="6285172206884"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "💎 MEMBANGUN EKOSISTEM MODULAR GARDA DUMAI KOTA - STANDARD SIGAP PRO..."

# 1. CLEAN & REBUILD SEMUA FOLDER
rm -rf css js modul
mkdir -p css js modul/admin modul/aksi modul/operator modul/peta

# 2. GLOBAL CSS (Biru Tua Midnight)
cat << 'EOF' > css/style.css
:root { --primary: #0d47a1; --primary-dark: #002171; --accent: #d32f2f; --bg: #f4f7f6; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 90px; }
.app-header { background: linear-gradient(135deg, var(--primary-dark), var(--primary)); color: white; padding: 25px 15px; border-radius: 0 0 25px 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 15px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 1000; }
.app-header img { width: 50px; height: 50px; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 18px; padding: 18px; margin-bottom: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
.btn-main { background: linear-gradient(to right, var(--primary), var(--primary-dark)); color: white; border: none; padding: 15px; border-radius: 12px; width: 100%; font-weight: bold; cursor: pointer; text-decoration: none; display: block; text-align: center; box-sizing: border-box; font-size: 16px; }
.bottom-nav { position: fixed; bottom: 15px; left: 15px; right: 15px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); display: flex; padding: 12px 0; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); z-index: 1000; border: 1px solid rgba(255,255,255,0.3); }
.nav-item { flex: 1; text-align: center; font-size: 10px; color: #999; text-decoration: none; }
.nav-item i { font-size: 22px; display: block; margin-bottom: 4px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; box-sizing: border-box; }
.badge { padding: 4px 8px; border-radius: 6px; font-size: 10px; color: white; font-weight: bold; text-transform: uppercase; }
.b-masuk { background: #9e9e9e; } .b-verifikasi { background: #0288d1; } .b-penanganan { background: #ff9800; } .b-selesai { background: #388e3c; }
EOF

# 3. MODUL ADMIN: LOGIN & COMMAND CENTER
# --- modul/admin/admin.js ---
cat << EOF > modul/admin/admin.js
const SAKTI = "$URL_SAKTI";
if(localStorage.getItem("role") !== "admin") window.location.href="login.html";

async function loadAdmin() {
    try {
        const r = await fetch(SAKTI);
        const d = await r.json();
        
        let logH = "";
        d.logs.reverse().slice(0,10).forEach(l => {
            logH += \`<div>[\${new Date(l[0]).toLocaleTimeString()}] \${l[1]} Online</div>\`;
        });
        document.getElementById('log-list').innerHTML = logH;

        let html = "";
        d.laporan.reverse().forEach((i, idx) => {
            if(idx === d.laporan.length - 1) return;
            html += \`<div class="card" style="border-left:5px solid var(--primary);">
                <div style="display:flex; justify-content:space-between;">
                    <small><b>\${i[1]}</b> | \${new Date(i[0]).toLocaleDateString()}</small>
                    <span class="badge b-\${i[6].toLowerCase()}">\${i[6]}</span>
                </div>
                <p style="font-size:13px; margin:10px 0;">\${i[3]}</p>
                <div style="display:flex; gap:5px;">
                    <button class="btn-main" style="padding:5px; font-size:10px; background:#0288d1" onclick="updStatus('\${i[0]}','Verifikasi')">VERIF</button>
                    <button class="btn-main" style="padding:5px; font-size:10px; background:#ff9800" onclick="updStatus('\${i[0]}','Penanganan')">TANGANI</button>
                    <button class="btn-main" style="padding:5px; font-size:10px; background:#388e3c" onclick="updStatus('\${i[0]}','Selesai')">DONE</button>
                    <a href="\${i[5]}" target="_blank" class="btn-main" style="padding:5px; font-size:10px; background:#333; width:40px;"><i class="fas fa-image"></i></a>
                </div>
            </div>\`;
        });
        document.getElementById('wf-list').innerHTML = html;
    } catch(e) { console.error(e); }
}

async function updStatus(id, st) {
    if(!confirm("Ubah status ke " + st + "?")) return;
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:id, status:st }) });
    alert("Status Diperbarui!"); window.location.reload();
}
loadAdmin();
EOF

# --- modul/admin/index.html ---
cat << 'EOF' > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Command Center</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;"><i class="fas fa-tower-broadcast"></i> COMMAND CENTER</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='login.html'"></i>
    </div>
    <div class="container">
        <div class="card">
            <h4><i class="fas fa-fingerprint"></i> Log Login Petugas</h4>
            <div id="log-list" style="font-size:11px; color:#666;">Memuat log...</div>
        </div>
        <div id="wf-list">Memuat laporan...</div>
    </div>
    <script src="admin.js"></script>
</body>
</html>
EOF

# --- modul/admin/login.html ---
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Login Garda Kota</title>
</head>
<body style="background:linear-gradient(135deg, #002171, #0d47a1); height:100vh; display:flex; align-items:center;">
    <div class="container" style="text-align:center;">
        <div class="card">
            <img src="../../assets/img/garda-dumaikota.png" style="width:100px; margin-bottom:15px;">
            <h3 style="margin:0;">OTENTIKASI PETUGAS</h3>
            <input type="text" id="user" placeholder="Username">
            <input type="password" id="pass" placeholder="Password">
            <button class="btn-main" onclick="auth()">MASUK</button>
        </div>
    </div>
    <script>
        async function auth() {
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;
            const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil", "binmas", "ramil01"];
            const kels = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
            const roles = ["lurah", "babinsa", "bhabin", "trantibkel", "pamong"];
            
            let role = "", label = "";
            if(admins.includes(u) && p === "dksiaga") { role="admin"; label=u.toUpperCase(); }
            else {
                kels.forEach(k => roles.forEach(r => {
                    if(u === \`\${r}-\${k}\` && p === "pantaudk") { role="operator"; label=u.toUpperCase().replace("-"," "); }
                }));
            }
            if(role) {
                localStorage.setItem("role", role); localStorage.setItem("user_label", label);
                fetch("$URL_SAKTI", { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'log', user:label }) });
                window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
            } else alert("Akses Ditolak!");
        }
    </script>
</body>
</html>
EOF

# 4. MODUL AKSI (MODULAR)
# --- modul/aksi/aksi.js ---
cat << EOF > modul/aksi/aksi.js
const WA_CAMAT = "$WA_CAMAT";
function trackMe() {
    const box = document.getElementById('gps-txt');
    box.innerText = "⌛ Melacak Lokasi...";
    navigator.geolocation.getCurrentPosition(p => {
        const lat = p.coords.latitude; const lng = p.coords.longitude;
        box.innerHTML = \`✅ <b>LOKASI TERKUNCI</b><br>Lat: \${lat}, Lng: \${lng}\`;
        localStorage.setItem("last_lat", lat); localStorage.setItem("last_lng", lng);
    });
}
function callWA() { window.location.href = "https://wa.me/" + WA_CAMAT + "?text=LAPOR DARURAT!"; }
EOF

# --- modul/aksi/index.html ---
cat << 'EOF' > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Aksi & Darurat</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-chevron-left"></i></a>
        <div style="font-weight:bold;">AKSI & DARURAT</div>
        <div style="width:20px;"></div>
    </div>
    <div class="container">
        <div class="card" style="text-align:center;">
            <h4><i class="fas fa-location-crosshairs"></i> Track Lokasi</h4>
            <div id="gps-txt" style="background:#e3f2fd; padding:15px; border-radius:15px; margin-bottom:10px;">Lokasi belum dilacak...</div>
            <button class="btn-main" onclick="trackMe()">KUNCI GPS</button>
        </div>
        <div class="card" style="background:#fff5f5;">
            <h4 style="color:#b71c1c;"><i class="fas fa-phone-volume"></i> Hotline Darurat</h4>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                <a href="tel:110" class="btn-main" style="background:#0d47a1; font-size:12px;">POLISI</a>
                <a href="tel:076538208" class="btn-main" style="background:#b71c1c; font-size:12px;">DAMKAR</a>
                <button onclick="callWA()" class="btn-main" style="background:#2e7d32; font-size:12px;">WA CAMAT</button>
                <a href="tel:076538208" class="btn-main" style="background:#ef6c00; font-size:12px;">BPBD</a>
            </div>
        </div>
    </div>
    <script src="aksi.js"></script>
</body>
</html>
EOF

# 5. MODUL OPERATOR (MODULAR)
# --- modul/operator/operator.js ---
cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");
document.getElementById('op-name').innerText = label;

async function kirim() {
    const file = document.getElementById('foto').files[0];
    const lat = localStorage.getItem("last_lat");
    if(!file || !lat) return alert("Foto & Kunci GPS di modul Aksi wajib!");
    
    const btn = document.getElementById('btnLapor');
    btn.innerText = "⌛ Mengirim..."; btn.disabled = true;

    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();

    await fetch(SAKTI, {
        method:'POST', mode:'no-cors',
        body: JSON.stringify({ nama:label, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:\`https://www.google.com/maps?q=\${lat},\${localStorage.getItem("last_lng")}\`, foto:dI.data.url })
    });
    alert("Laporan Terkirim!"); window.location.reload();
}
EOF

# --- modul/operator/index.html ---
cat << 'EOF' > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;">OPERATOR PANEL</div>
        <i class="fas fa-sign-out-alt" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="background:#e8f5e9;">
            <small>Petugas:</small><h4 id="op-name" style="margin:0;">-</h4>
        </div>
        <div class="card">
            <select id="kat"><option>Banjir Rob</option><option>Sampah</option><option>Kamtibmas</option></select>
            <textarea id="ket" placeholder="Detail kejadian..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnLapor" style="margin-top:15px;" onclick="kirim()">KIRIM LAPORAN</button>
        </div>
    </div>
    <script src="operator.js"></script>
</body>
</html>
EOF

# 6. MODUL PETA (MODULAR)
# --- modul/peta/peta.js ---
cat << EOF > modul/peta/peta.js
var map = L.map('map').setView([1.680, 101.448], 14);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

async function loadPeta() {
    const r = await fetch("$URL_SAKTI");
    const d = await r.json();
    d.laporan.forEach((item, idx) => {
        if(idx === 0) return;
        const coords = item[4].match(/q=(-?\d+\.\d+),(-?\d+\.\d+)/);
        if(coords) {
            let color = item[6] === 'Selesai' ? 'green' : 'red';
            L.circleMarker([coords[1], coords[2]], {color: color}).addTo(map)
                .bindPopup(\`<b>\${item[1]}</b><br>\${item[3]}<br><img src="\${item[5]}" style="width:100px">\`);
        }
    });
}
loadPeta();
EOF

# --- modul/peta/index.html ---
cat << 'EOF' > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Peta Pantau</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-chevron-left"></i></a>
        <div style="font-weight:bold;">PETA SEBARAN</div>
        <i class="fas fa-refresh" onclick="location.reload()"></i>
    </div>
    <div id="map" style="height:calc(100vh - 135px);"></div>
    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-house"></i>Home</a>
        <a href="index.html" class="nav-item active"><i class="fas fa-map"></i>Peta</a>
        <a href="../aksi/index.html" class="nav-item"><i class="fas fa-bolt"></i>Aksi</a>
    </nav>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="peta.js"></script>
</body>
</html>
EOF

# 7. INDEX UTAMA (index.html)
cat << EOF > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota</title>
</head>
<body>
    <div style="background:#ffeb3b; color:#b71c1c; padding:5px; font-size:12px; font-weight:bold;">
        <marquee scrollamount="5">⚠️ WASPADA PASANG KELING: Wilayah Pesisir Dumai Kota Siaga Banjir Rob Malam Ini!</marquee>
    </div>
    <div class="app-header">
        <img src="assets/img/garda-dumaikota.png" alt="Logo">
        <div style="text-align:center;">
            <div style="font-size:10px; opacity:0.8;">PEMERINTAH KOTA DUMAI</div>
            <div style="font-size:18px; font-weight:bold;">GARDA DUMAI KOTA</div>
        </div>
        <i class="fas fa-bell"></i>
    </div>
    <div class="container">
        <div class="card" style="border-left:6px solid #d32f2f;">
            <h4 style="margin:0; color:#d32f2f;"><i class="fas fa-house-crack"></i> Info Gempa BMKG</h4>
            <div id="gempa" style="font-size:13px; font-weight:bold; margin-top:5px;">Memuat data...</div>
        </div>
        <div style="display:flex; gap:12px; margin-bottom:15px;">
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 id="st-proses" style="color:#f39c12; margin:0">0</h2><small>PROSES</small></div>
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 id="st-selesai" style="color:#2ecc71; margin:0">0</h2><small>SELESAI</small></div>
        </div>
        <a href="modul/aksi/index.html" class="btn-main"><i class="fas fa-bolt"></i> AKSI CEPAT & DARURAT</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house-chimney"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-marked-alt"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i>Aksi</a>
        <a href="modul/admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Petugas</a>
    </nav>
    <script>
        async function fetchAPI() {
            const r = await fetch("$URL_SAKTI");
            const d = await r.json();
            document.getElementById('st-proses').innerText = d.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
            document.getElementById('st-selesai').innerText = d.laporan.filter(i => i[6] === 'Selesai').length;
            const gRes = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
            const gData = await gRes.json();
            const g = gData.Infogempa.gempa;
            document.getElementById('gempa').innerText = \`M \${g.Magnitude} | \${g.Wilayah}\`;
        }
        fetchAPI();
    </script>
</body>
</html>
EOF

echo "------------------------------------------------------------"
echo "🌟 GARDA DUMAI KOTA PARIPURNA - MODULAR SYSTEM READY!"
echo "📍 Semua file HTML, CSS, dan JS sudah terpisah di folder modul."
echo "📍 Database: Arsip Garda Kota (...P5ww/exec)"
echo "------------------------------------------------------------"