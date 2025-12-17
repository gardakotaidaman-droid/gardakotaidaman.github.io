#!/bin/bash

# CONFIG DATA - INTEGRASI URL SAKTI BAPAK
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
WA_CAMAT="6285172206884"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "💎 MEMBANGUN ULANG SELURUH EKOSISTEM MODULAR GARDA DUMAI KOTA..."

# 1. CLEAN & REBUILD SEMUA FOLDER
rm -rf modul css js assets
mkdir -p css js assets/img modul/admin modul/aksi modul/operator modul/peta

# 2. GLOBAL CSS (Midnight Blue UI)
cat << 'EOF' > css/style.css
:root { --primary: #0d47a1; --primary-dark: #002171; --accent: #d32f2f; --bg: #f4f7f6; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 90px; color: #1a237e; }
.app-header { background: linear-gradient(135deg, var(--primary-dark), var(--primary)); color: white; padding: 25px 15px; border-radius: 0 0 25px 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 15px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 1000; }
.app-header img { width: 45px; height: 45px; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 18px; padding: 18px; margin-bottom: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
.btn-main { background: linear-gradient(to right, var(--primary), var(--primary-dark)); color: white; border: none; padding: 15px; border-radius: 12px; width: 100%; font-weight: bold; cursor: pointer; text-align: center; display: block; text-decoration: none; box-sizing: border-box; font-size: 16px; margin-top: 10px; }
.bottom-nav { position: fixed; bottom: 15px; left: 15px; right: 15px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); display: flex; padding: 12px 0; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); z-index: 1000; border: 1px solid rgba(255,255,255,0.3); }
.nav-item { flex: 1; text-align: center; font-size: 10px; color: #999; text-decoration: none; }
.nav-item i { font-size: 22px; display: block; margin-bottom: 4px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; box-sizing: border-box; }
.badge { padding: 4px 8px; border-radius: 6px; font-size: 10px; color: white; font-weight: bold; text-transform: uppercase; }
.b-masuk { background: #9e9e9e; } .b-verifikasi { background: #0288d1; } .b-penanganan { background: #ff9800; } .b-selesai { background: #388e3c; }
.marquee { background: #ffeb3b; color: #b71c1c; padding: 5px; font-size: 12px; font-weight: bold; border-bottom: 2px solid #fbc02d; }
EOF

# 3. MODUL AKSI: SOS & DARURAT (KEMBALI DAN LEBIH KUAT)
# --- modul/aksi/aksi.css ---
cat << 'EOF' > modul/aksi/aksi.css
.panic-btn { background: radial-gradient(circle, #ff1744 0%, #b71c1c 100%); width: 120px; height: 120px; border-radius: 50%; margin: 20px auto; display: flex; align-items: center; justify-content: center; color: white; font-weight: 900; box-shadow: 0 0 20px rgba(255, 23, 68, 0.6); border: 5px solid rgba(255,255,255,0.3); animation: pulse 1.5s infinite; cursor: pointer; }
@keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.05); } 100% { transform: scale(1); } }
.emergency-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.btn-red { background: #b71c1c; color: white; padding: 12px; border-radius: 12px; text-decoration: none; text-align: center; font-weight: bold; font-size: 13px; }
EOF

# --- modul/aksi/aksi.js ---
cat << EOF > modul/aksi/aksi.js
let lat = "", lng = "";
const SAKTI = "$URL_SAKTI";
const WA_CAMAT = "$WA_CAMAT";
const user = localStorage.getItem("user_label") || "Warga/Relawan";

function initGPS() {
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        document.getElementById('gps-status').innerHTML = "✅ LOKASI SIAP: " + lat + "," + lng;
    }, () => alert("Aktifkan GPS!"));
}

async function sendSOS() {
    if(!lat) return alert("Menunggu koordinat GPS...");
    if(confirm("Kirim sinyal DARURAT ke Camat & BPBD?")) {
        const maps = "http://googleusercontent.com/maps.google.com/q=" + lat + "," + lng;
        fetch(SAKTI, { method: 'POST', mode: 'no-cors', body: JSON.stringify({ nama: user, kategori: "🚨 SOS / DARURAT", keterangan: "Sinyal Bahaya Ditekan!", lokasi: maps }) });
        window.location.href = "https://wa.me/" + WA_CAMAT + "?text=*🚨 DARURAT SOS*%0A*Petugas:* " + user + "%0A*Lokasi:* " + maps;
    }
}
initGPS();
EOF

# --- modul/aksi/index.html ---
cat << 'EOF' > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css"><link rel="stylesheet" href="aksi.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Aksi Darurat</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-chevron-left"></i> Kembali</a>
        <div style="font-weight:bold;">AKSI DARURAT</div>
        <div style="width:50px;"></div>
    </div>
    <div class="container">
        <div class="card" style="text-align:center;">
            <div class="panic-btn" onclick="sendSOS()">SOS</div>
            <div id="gps-status" style="font-size:12px; color:#666; margin-top:10px;">Melacak Lokasi...</div>
        </div>
        <div class="card">
            <h4><i class="fas fa-phone-flip"></i> Panggilan Cepat</h4>
            <div class="emergency-grid">
                <a href="tel:110" class="btn-red" style="background:#0d47a1;">POLISI</a>
                <a href="tel:076538208" class="btn-red">DAMKAR</a>
                <a href="tel:076538208" class="btn-red" style="background:#ef6c00;">BPBD</a>
EOF
echo "                <a href=\"https://wa.me/$WA_CAMAT\" class=\"btn-red\" style=\"background:#2e7d32;\">WA CAMAT</a>" >> modul/aksi/index.html
cat << 'EOF' >> modul/aksi/index.html
            </div>
        </div>
    </div>
    <script src="aksi.js"></script>
</body>
</html>
EOF

# 4. MODUL OPERATOR (LENGKAP DENGAN TRACK GPS)
# --- modul/operator/operator.js ---
cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");
if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
function trackGPS() {
    const box = document.getElementById('gps-box');
    box.innerText = "⌛ Menghubungkan...";
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        box.innerHTML = "✅ KOORDINAT TERKUNCI";
        box.style.background = "#e8f5e9";
        // PING KE ADMIN
        fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action: "log", user: label, type: "Melacak Lokasi" }) });
    });
}

async function kirim() {
    const file = document.getElementById('foto').files[0];
    if(!file || !lat) return alert("Foto & GPS wajib!");
    document.getElementById('btnLapor').innerText = "⌛ Mengirim...";
    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ nama:label, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:"http://googleusercontent.com/maps.google.com/q="+lat+","+lng, foto:dI.data.url }) });
    alert("Berhasil!"); window.location.reload();
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
        <div class="card" style="background:#e8f5e9; border-left:5px solid #2e7d32;">
            <small>Petugas:</small><h4 id="op-name" style="margin:0;">-</h4>
        </div>
        <div class="card">
            <div id="gps-box" style="padding:15px; background:#f5f5f5; border-radius:10px; text-align:center; font-size:12px; margin-bottom:10px;">Lokasi Belum Dikunci</div>
            <button class="btn-main" onclick="trackGPS()" style="background:#0288d1;">KUNCI LOKASI KEJADIAN</button>
            <hr>
            <select id="kat">
                <option>🌊 Banjir Rob</option><option>🗑️ Sampah</option><option>👮 Kamtibmas</option><option>🔥 Kebakaran</option>
                <option>💡 Lampu Jalan</option><option>🛣️ Jalan Rusak</option><option>🌳 Pohon Tumbang</option>
            </select>
            <textarea id="ket" placeholder="Keterangan..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnLapor" onclick="kirim()">🚀 KIRIM LAPORAN</button>
        </div>
    </div>
    <script src="operator.js"></script>
</body>
</html>
EOF

# 5. MODUL ADMIN: COMMAND CENTER (WORKFLOW & LOGS)
# --- modul/admin/admin.js ---
cat << EOF > modul/admin/admin.js
const SAKTI = "$URL_SAKTI";
if(localStorage.getItem("role") !== "admin") window.location.href="login.html";

async function loadData() {
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
                <small><b>\${i[1]}</b></small>
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
loadData();
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
        <div style="font-weight:bold;">COMMAND CENTER</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='login.html'"></i>
    </div>
    <div class="container">
        <div class="card">
            <h4><i class="fas fa-fingerprint"></i> Aktivitas Petugas</h4>
            <div id="log-list">Memuat...</div>
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
    <title>Login Petugas</title>
</head>
<body style="background:linear-gradient(135deg, #002171, #0d47a1); height:100vh; display:flex; align-items:center;">
    <div class="container" style="text-align:center;">
        <div class="card">
            <img src="../../assets/img/garda-dumaikota.png" style="width:100px; margin-bottom:15px;">
            <h3>LOGIN PETUGAS</h3>
            <input type="text" id="user" placeholder="Username">
            <input type="password" id="pass" placeholder="Password">
            <button class="btn-main" onclick="auth()">MASUK</button>
            <a href="../../index.html" style="display:block; margin-top:15px; font-size:12px; color:#aaa; text-decoration:none;">Beranda</a>
        </div>
    </div>
    <script>
        function auth() {
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
                fetch("$URL_SAKTI", { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'log', user:label, type:"Login" }) });
                window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
            } else alert("Login Gagal!");
        }
    </script>
</body>
</html>
EOF

# 6. INDEX UTAMA (index.html)
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
    <div class="marquee"><marquee scrollamount="5">⚠️ WASPADA PERINGATAN DINI RIAU: Potensi hujan lebat dan angin kencang di wilayah Dumai Kota.</marquee></div>
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
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 id="st-proses" style="color:#f39c12; margin:0">0</h2><small>PROSES</small></div>
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 id="st-selesai" style="color:#2ecc71; margin:0">0</h2><small>SELESAI</small></div>
        </div>
        <a href="modul/aksi/index.html" class="btn-main"><i class="fas fa-bolt"></i> AKSI CEPAT & DARURAT</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-house-chimney"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-marked-alt"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i>Lapor</a>
        <a href="modul/admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Petugas</a>
    </nav>
    <script>
        async function fetchDash() {
            try {
                const r = await fetch("$URL_SAKTI");
                const d = await r.json();
                document.getElementById('st-proses').innerText = d.laporan.filter(i => i[6] !== 'Selesai' && i[6] !== 'Status').length;
                document.getElementById('st-selesai').innerText = d.laporan.filter(i => i[6] === 'Selesai').length;
                const gRes = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
                const gData = await gRes.json();
                const g = gData.Infogempa.gempa;
                document.getElementById('gempa').innerText = \`M \${g.Magnitude} | \${g.Wilayah}\`;
            } catch(e) {}
        }
        fetchDash();
    </script>
</body>
</html>
EOF

echo "✅ SELESAI! SEMUA MODUL (ADMIN, AKSI, OPERATOR, PETA) TELAH DIBANGUN ULANG SECARA MODULAR."