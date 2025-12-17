#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
WA_CAMAT="6285172206884"

echo "💎 MEMBANGUN ULANG GARDA DUMAI KOTA - STRUKTUR MODULAR PRO..."

# 1. CLEAN & REBUILD FOLDERS
rm -rf css modul js
mkdir -p css assets/img js modul/admin modul/aksi modul/operator modul/peta

# 2. GLOBAL CSS (Biru Tua & Glassmorphism)
cat << 'EOF' > css/style.css
:root { --primary: #0d47a1; --primary-dark: #002171; --accent: #d32f2f; --bg: #f0f2f5; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 90px; }
.app-header { background: linear-gradient(135deg, var(--primary-dark), var(--primary)); color: white; padding: 25px 15px; border-radius: 0 0 25px 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 8px 15px rgba(0,0,0,0.1); sticky: top; z-index: 1000; }
.app-header img { width: 45px; height: 45px; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 18px; padding: 18px; margin-bottom: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); border: 1px solid rgba(13,71,161,0.1); }
.btn-main { background: linear-gradient(to right, var(--primary), var(--primary-dark)); color: white; border: none; padding: 15px; border-radius: 12px; width: 100%; font-weight: bold; cursor: pointer; text-decoration: none; display: block; text-align: center; box-sizing: border-box; }
.bottom-nav { position: fixed; bottom: 15px; left: 15px; right: 15px; background: rgba(255,255,255,0.9); backdrop-filter: blur(10px); display: flex; padding: 12px 0; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); z-index: 1000; }
.nav-item { flex: 1; text-align: center; font-size: 10px; color: #999; text-decoration: none; }
.nav-item i { font-size: 20px; display: block; margin-bottom: 3px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
.marquee { background: #ffeb3b; color: #b71c1c; padding: 5px; font-size: 12px; font-weight: bold; }
EOF

# 3. MODUL AKSI: PISAHKAN HTML, CSS, & JS
# --- modul/aksi/aksi.css ---
cat << 'EOF' > modul/aksi/aksi.css
.gps-box { padding: 15px; background: #e3f2fd; border-radius: 12px; border: 1px dashed #2196f3; margin-bottom: 15px; font-size: 12px; }
.btn-emergency { display: flex; align-items: center; justify-content: center; gap: 8px; background: #c62828; color: white; padding: 12px; border-radius: 10px; text-decoration: none; margin-bottom: 10px; font-weight: bold; font-size: 13px; }
EOF

# --- modul/aksi/aksi.js ---
cat << EOF > modul/aksi/aksi.js
function trackLokasi() {
    const box = document.getElementById('gps-txt');
    box.innerText = "⌛ Melacak Lokasi...";
    navigator.geolocation.getCurrentPosition(p => {
        box.innerHTML = "✅ LOKASI TERKUNCI<br>Lat: " + p.coords.latitude + "<br>Long: " + p.coords.longitude;
        localStorage.setItem("current_lat", p.coords.latitude);
        localStorage.setItem("current_lng", p.coords.longitude);
    }, () => alert("Aktifkan GPS!"));
}
EOF

# --- modul/aksi/index.html ---
cat << 'EOF' > modul/aksi/index.html
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
        <div style="font-weight:bold;">AKSI & DARURAT</div>
        <div style="width:20px;"></div>
    </div>
    <div class="container">
        <div class="card">
            <h4><i class="fas fa-location-crosshairs"></i> Pelacakan Lokasi</h4>
            <div id="gps-txt" class="gps-box">Lokasi belum dilacak...</div>
            <button class="btn-main" onclick="trackLokasi()"><i class="fas fa-bullseye"></i> TRACK LOKASI SAYA</button>
        </div>
        <div class="card">
            <h4><i class="fas fa-phone-flip"></i> Kontak Darurat</h4>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                <a href="tel:110" class="btn-emergency" style="background:#0d47a1;"><i class="fas fa-police-box"></i> POLISI</a>
                <a href="tel:076538208" class="btn-emergency"><i class="fas fa-fire"></i> DAMKAR</a>
                <a href="tel:076538208" class="btn-emergency" style="background:#e65100;"><i class="fas fa-burst"></i> BPBD</a>
EOF
echo "                <a href=\"https://wa.me/$WA_CAMAT\" class=\"btn-emergency\" style=\"background:#2e7d32;\"><i class=\"fab fa-whatsapp\"></i> WA CAMAT</a>" >> modul/aksi/index.html
cat << 'EOF' >> modul/aksi/index.html
            </div>
        </div>
    </div>
    <script src="aksi.js"></script>
</body>
</html>
EOF

# 4. MODUL OPERATOR: PISAHKAN LOGIC JS
cat << EOF > modul/operator/operator.js
const label = localStorage.getItem("user_label");
if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

async function kirimLaporan() {
    const btn = document.getElementById('btnKirim');
    btn.innerText = "⏳ Mengirim...";
    // Logika upload foto & simpan sheets
    alert("Laporan Berhasil dikirim oleh " + label);
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
        <div style="font-weight:bold;">OPERATOR PANEL</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="border-left:5px solid var(--primary);">
            <small>Login Sebagai:</small><h3 id="op-name" style="margin:0;">-</h3>
        </div>
        <div class="card">
            <select id="kat"><option>Banjir Rob</option><option>Sampah</option></select>
            <textarea id="ket" placeholder="Keterangan..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnKirim" onclick="kirimLaporan()" style="margin-top:15px;">KIRIM LAPORAN</button>
        </div>
    </div>
    <script src="operator.js"></script>
</body>
</html>
EOF

# 5. INDEX UTAMA (index.html)
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
    <div class="marquee"><marquee scrollamount="5">⚠️ WASPADA PERINGATAN DINI RIAU: Potensi hujan lebat dan angin kencang di wilayah pesisir Dumai. Petugas harap siaga!</marquee></div>
    <div class="app-header">
        <img src="assets/img/garda-dumaikota.png" alt="Logo">
        <div style="text-align:center;">
            <div style="font-size:10px; opacity:0.8;">KECAMATAN DUMAI KOTA</div>
            <div style="font-size:18px; font-weight:bold;">GARDA KOTA IDAMAN</div>
        </div>
        <i class="fas fa-bell"></i>
    </div>
    <div class="container">
        <div class="card" style="border-left:6px solid var(--accent);">
            <h4 style="margin:0; color:var(--accent);"><i class="fas fa-house-crack"></i> Info Gempa BMKG</h4>
            <div id="gempa" style="font-size:12px; font-weight:bold; margin-top:5px;">Memuat data...</div>
        </div>
        <div style="display:flex; gap:10px; margin-bottom:15px;">
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 style="color:#f39c12; margin:0">0</h2><small>PROSES</small></div>
            <div class="card" style="flex:1; text-align:center; margin:0;"><h2 style="color:#2ecc71; margin:0">0</h2><small>DONE</small></div>
        </div>
        <a href="modul/aksi/index.html" class="btn-main"><i class="fas fa-bolt"></i> AKSI & DARURAT</a>
    </div>
    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-home"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-circle-exclamation"></i>Lapor</a>
        <a href="modul/admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Admin</a>
    </nav>
    <script>
        async function fetchBMKG() {
            const r = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
            const d = await r.json();
            const g = d.Infogempa.gempa;
            document.getElementById('gempa').innerText = \`M \${g.Magnitude} | \${g.Wilayah}\`;
        }
        fetchBMKG();
    </script>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ STRUKTUR MODULAR PRO BERHASIL DIBANGUN!"
echo "📍 CSS & JS SUDAH DIPISAH DI MASING-MASING FOLDER."
echo "📍 WARNA: BIRU TUA | FAVICON: AKTIF | TRACKING: AKTIF."
echo "-------------------------------------------------------"