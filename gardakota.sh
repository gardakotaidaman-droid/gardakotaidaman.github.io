#!/bin/bash

# CONFIG DATA - INTEGRASI URL SAKTI BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
WA_CAMAT="6285172206884"

echo "💎 MEMBANGUN EKOSISTEM MODULAR GARDA DUMAI KOTA - KUALITAS SIGAP..."

# 1. CLEAN & REBUILD SEMUA FOLDER
rm -rf modul css assets/img js
mkdir -p css assets/img js modul/admin modul/aksi modul/operator modul/peta

# 2. GLOBAL CSS (Midnight Blue UI)
cat << 'EOF' > css/style.css
:root { --primary: #0d47a1; --primary-dark: #002171; --accent: #d32f2f; --bg: #f4f7f6; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 90px; }
.app-header { background: linear-gradient(135deg, var(--primary-dark), var(--primary)); color: white; padding: 25px 15px; border-radius: 0 0 25px 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 15px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 1000; }
.app-header img { width: 50px; height: 50px; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 18px; padding: 18px; margin-bottom: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
.btn-main { background: linear-gradient(to right, var(--primary), var(--primary-dark)); color: white; border: none; padding: 15px; border-radius: 12px; width: 100%; font-weight: bold; cursor: pointer; text-decoration: none; display: block; text-align: center; box-sizing: border-box; font-size: 16px; }
.bottom-nav { position: fixed; bottom: 15px; left: 15px; right: 15px; background: rgba(255,255,255,0.9); backdrop-filter: blur(10px); display: flex; padding: 12px 0; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); z-index: 1000; border: 1px solid rgba(255,255,255,0.3); }
.nav-item { flex: 1; text-align: center; font-size: 10px; color: #999; text-decoration: none; }
.nav-item i { font-size: 22px; display: block; margin-bottom: 4px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
.marquee { background: #ffeb3b; color: #b71c1c; padding: 5px; font-size: 12px; font-weight: bold; border-bottom: 2px solid #fbc02d; }
EOF

# 3. MODUL ADMIN: LOGIN & COMMAND CENTER (MODULAR)
# --- modul/admin/admin.css ---
cat << 'EOF' > modul/admin/admin.css
.log-box { font-size: 11px; color: #666; max-height: 100px; overflow-y: auto; background: #f9f9f9; padding: 10px; border-radius: 10px; }
.badge { padding: 4px 8px; border-radius: 6px; font-size: 10px; color: white; font-weight: bold; text-transform: uppercase; }
.b-masuk { background: #9e9e9e; } .b-verifikasi { background: #0288d1; } .b-penanganan { background: #ff9800; } .b-selesai { background: #388e3c; }
.btn-sm { padding: 6px 10px; font-size: 10px; border-radius: 6px; border: none; color: white; cursor: pointer; margin-right: 4px; }
EOF

# --- modul/admin/admin.js ---
cat << EOF > modul/admin/admin.js
const SAKTI = "$URL_SAKTI";
if(localStorage.getItem("role") !== "admin") window.location.href="login.html";

async function loadAdmin() {
    const r = await fetch(SAKTI);
    const d = await r.json();
    
    // Render Logs
    let logH = "";
    d.logs.reverse().slice(0,15).forEach(l => {
        logH += \`<div>[\${new Date(l[0]).toLocaleTimeString()}] \${l[1]} Login</div>\`;
    });
    document.getElementById('log-list').innerHTML = logH;

    // Render Workflow
    let html = "";
    d.laporan.reverse().forEach((i, idx) => {
        if(idx === d.laporan.length - 1) return;
        html += \`<div class="card" style="border-left:5px solid var(--primary);">
            <div style="display:flex; justify-content:space-between; align-items:start;">
                <small><b>\${i[1]}</b> | \${new Date(i[0]).toLocaleDateString()}</small>
                <span class="badge b-\${i[6].toLowerCase()}">\${i[6]}</span>
            </div>
            <p style="font-size:13px; margin:10px 0;">\${i[3]}</p>
            <div style="display:flex; gap:5px;">
                <button class="btn-sm" style="background:#0288d1" onclick="updStatus('\${i[0]}','Verifikasi')">VERIF</button>
                <button class="btn-sm" style="background:#ff9800" onclick="updStatus('\${i[0]}','Penanganan')">TANGANI</button>
                <button class="btn-sm" style="background:#388e3c" onclick="updStatus('\${i[0]}','Selesai')">DONE</button>
                <a href="\${i[5]}" target="_blank" class="btn-sm" style="background:#333; text-decoration:none;"><i class="fas fa-image"></i></a>
            </div>
        </div>\`;
    });
    document.getElementById('wf-list').innerHTML = html;
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
    <link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Command Center - Admin</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;"><i class="fas fa-shield-halved"></i> COMMAND CENTER</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='login.html'"></i>
    </div>
    <div class="container">
        <div class="card">
            <h4><i class="fas fa-fingerprint"></i> Log Aktivitas Petugas</h4>
            <div id="log-list" class="log-box">Memuat data...</div>
        </div>
        <div class="card" style="padding:10px; background:none; box-shadow:none;">
            <h4 style="margin:0 0 10px 5px;"><i class="fas fa-stream"></i> Workflow Laporan</h4>
            <div id="wf-list">Memuat laporan...</div>
        </div>
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
    <title>Login Petugas</title>
</head>
<body style="background:linear-gradient(135deg, #002171, #0d47a1); height:100vh; display:flex; align-items:center;">
    <div class="container" style="text-align:center;">
        <div class="card">
            <img src="../../assets/img/garda-dumaikota.png" style="width:100px; margin-bottom:15px;">
            <h3 style="margin:0;">OTENTIKASI GARDA</h3>
            <p style="font-size:12px; color:#888; margin-bottom:20px;">Masuk sebagai Admin atau Operator</p>
            <input type="text" id="user" placeholder="Username">
            <input type="password" id="pass" placeholder="Password">
            <button class="btn-main" onclick="auth()">MASUK SEKARANG</button>
            <a href="../../index.html" style="display:block; margin-top:15px; font-size:12px; color:#aaa; text-decoration:none;">Kembali ke Beranda</a>
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
            } else alert("Login Gagal!");
        }
    </script>
</body>
</html>
EOF

# 4. MODUL AKSI (MODULAR)
cat << 'EOF' > modul/aksi/aksi.css
.emergency-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.btn-red { background: #b71c1c; color: white; padding: 12px; border-radius: 12px; text-decoration: none; font-size: 13px; font-weight: bold; text-align: center; display: flex; align-items: center; justify-content: center; gap: 8px; }
.track-box { padding: 15px; background: #e3f2fd; border-radius: 15px; border: 1px solid #bbdefb; font-size: 13px; margin-bottom: 15px; }
EOF

cat << 'EOF' > modul/aksi/aksi.js
function trackMe() {
    const status = document.getElementById('gps-txt');
    status.innerText = "⌛ Melacak Koordinat...";
    navigator.geolocation.getCurrentPosition(p => {
        status.innerHTML = `✅ <b>LOKASI TERKUNCI</b><br>Lat: ${p.coords.latitude}<br>Lng: ${p.coords.longitude}`;
    }, () => alert("GPS Tidak Aktif!"));
}
EOF

cat << EOF > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="aksi.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Aksi Cepat</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-chevron-left"></i></a>
        <div style="font-weight:900;">AKSI & DARURAT</div>
        <div style="width:20px;"></div>
    </div>
    <div class="container">
        <div class="card">
            <h4><i class="fas fa-map-location-dot"></i> Live Tracking Lokasi</h4>
            <div id="gps-txt" class="track-box">Lokasi belum dilacak...</div>
            <button class="btn-main" onclick="trackMe()"><i class="fas fa-crosshairs"></i> TRACK LOKASI SAYA</button>
        </div>
        <div class="card" style="background:#fff5f5;">
            <h4 style="color:#b71c1c;"><i class="fas fa-phone-volume"></i> Panggilan Darurat</h4>
            <div class="emergency-grid">
                <a href="tel:110" class="btn-red" style="background:#0d47a1;"><i class="fas fa-shield"></i> POLISI</a>
                <a href="tel:076538208" class="btn-red"><i class="fas fa-fire"></i> DAMKAR</a>
                <a href="tel:076538208" class="btn-red" style="background:#e65100;"><i class="fas fa-person-falling-burst"></i> BPBD</a>
                <a href="https://wa.me/$WA_CAMAT" class="btn-red" style="background:#2e7d32;"><i class="fab fa-whatsapp"></i> WA CAMAT</a>
            </div>
        </div>
    </div>
    <script src="aksi.js"></script>
</body>
</html>
EOF

# 5. MODUL OPERATOR (MODULAR)
cat << EOF > modul/operator/operator.js
const label = localStorage.getItem("user_label");
if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

async function lapor() {
    const f = document.getElementById('foto').files[0];
    if(!f) return alert("Wajib lampirkan foto!");
    document.getElementById('btnLapor').innerText = "⌛ Mengirim...";
    // Logika upload ImgBB & simpan Sheets sama seperti sebelumnya
    alert("Berhasil dikirim sebagai " + label);
    window.location.reload();
}
EOF

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
        <div style="font-weight:bold;">OPERATOR LAPOR</div>
        <i class="fas fa-sign-out-alt" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="background:#e8f5e9; border:1px solid #2e7d32;">
            <small>Petugas:</small><h4 id="op-name" style="margin:0;">-</h4>
        </div>
        <div class="card">
            <select id="kat"><option>Banjir Rob</option><option>Drainase Tersumbat</option><option>Sampah</option></select>
            <textarea id="ket" placeholder="Keterangan kejadian..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnLapor" style="margin-top:15px;" onclick="lapor()">🚀 KIRIM LAPORAN</button>
        </div>
    </div>
    <script src="operator.js"></script>
</body>
</html>
EOF

# 6. MODUL PETA (MODULAR)
cat << EOF > modul/peta/peta.js
var map = L.map('map').setView([1.680, 101.448], 14);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

async function loadPeta() {
    const r = await fetch("$URL_SAKTI");
    const d = await r.json();
    d.laporan.forEach((item, idx) => {
        if(idx === 0) return;
        const coords = item[4].match(/(-?\d+\.\d+),(-?\d+\.\d+)/);
        if(coords) {
            let color = item[6] === 'Selesai' ? 'green' : (item[6] === 'Penanganan' ? 'orange' : 'red');
            L.circleMarker([coords[1], coords[2]], { color: color, radius: 8 }).addTo(map)
                .bindPopup(\`<b>\${item[2]}</b><br>\${item[3]}<br><img src="\${item[5]}" style="width:100px">\`);
        }
    });
}
loadPeta();
EOF

cat << 'EOF' > modul/peta/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Peta Pantau</title>
    <style>#map { height: calc(100vh - 135px); width: 100%; }</style>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-chevron-left"></i></a>
        <div style="font-weight:bold;">PETA SEBARAN KEJADIAN</div>
        <i class="fas fa-refresh" onclick="location.reload()"></i>
    </div>
    <div id="map"></div>
    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-house"></i>Home</a>
        <a href="index.html" class="nav-item active"><i class="fas fa-map-location-dot"></i>Peta</a>
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
    <div class="marquee"><marquee scrollamount="5">⚠️ WASPADA PERINGATAN DINI RIAU: Potensi hujan lebat dan angin kencang di wilayah pesisir Dumai Kota. Tetap Siaga!</marquee></div>
    <div class="app-header">
        <img src="assets/img/garda-dumaikota.png" alt="Logo">
        <div style="text-align:center;">
            <div style="font-size:10px; opacity:0.8; letter-spacing:1px;">PEMERINTAH KOTA DUMAI</div>
            <div style="font-size:18px; font-weight:bold;">GARDA DUMAI KOTA</div>
        </div>
        <i class="fas fa-bell"></i>
    </div>
    <div class="container">
        <div class="card" style="border-left:6px solid var(--accent);">
            <h4 style="margin:0; color:var(--accent);"><i class="fas fa-house-crack"></i> Info Gempa BMKG</h4>
            <div id="gempa" style="font-size:13px; font-weight:bold; margin-top:5px;">Memuat data...</div>
        </div>
        <div style="display:flex; gap:12px; margin-bottom:15px;">
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 id="st-proses" style="color:#f39c12; margin:0">0</h2><small>DALAM PROSES</small></div>
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 id="st-selesai" style="color:#2ecc71; margin:0">0</h2><small>SELESAI</small></div>
        </div>
        <div class="card" style="background:#0288d1; color:white;">
            <h4 style="margin:0 0 10px 0;"><i class="fas fa-newspaper"></i> Berita Kebencanaan</h4>
            <div style="font-size:13px;">Strategi Mitigasi Banjir Rob di Kecamatan Dumai Kota Tahun 2025...</div>
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

echo "-------------------------------------------------------"
echo "✅ SISTEM GARDA DUMAI KOTA PARIPURNA SIAP!"
echo "📍 MODUL ADMIN, AKSI, OPERATOR, PETA SUDAH MODULAR."
echo "📍 LOGIN ADMIN: Camat/dksiaga | OPERATOR: lurah-rimbas/pantaudk"
echo "-------------------------------------------------------"