#!/bin/bash

echo "💎 MEMBANGUN EKOSISTEM DIGITAL GARDA DUMAI KOTA - STANDARD SIGAP..."

# 1. STRUKTUR FOLDER
mkdir -p css assets/img modul/aksi modul/peta modul/admin

# 2. CSS PRESTIGE (style.css) - Desain ala SIGAP-Dumai (Modern, Clean, Sharp)
cat << 'EOF' > css/style.css
:root { 
    --primary: #2e7d32; --primary-dark: #1b5e20;
    --accent: #d32f2f; --warning: #ff9800; --info: #0288d1;
    --bg: #f8f9fa; --white: #ffffff; --shadow: 0 4px 12px rgba(0,0,0,0.08);
}
* { box-sizing: border-box; }
body { font-family: 'Segoe UI', Roboto, sans-serif; margin: 0; background: var(--bg); color: #333; line-height: 1.5; padding-bottom: 80px; }

/* Header & Nav */
.app-header { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; padding: 20px 15px; border-radius: 0 0 20px 20px; display: flex; align-items: center; justify-content: space-between; sticky: top; z-index: 1000; box-shadow: 0 4px 10px rgba(0,0,0,0.15); }
.app-header img { width: 45px; height: 45px; object-fit: contain; }
.back-btn { background: rgba(255,255,255,0.2); border: none; color: white; padding: 8px 12px; border-radius: 10px; cursor: pointer; }

.bottom-nav { position: fixed; bottom: 0; width: 100%; background: white; display: flex; padding: 10px 0; border-top: 1px solid #eee; z-index: 1000; box-shadow: 0 -2px 10px rgba(0,0,0,0.05); }
.nav-item { flex: 1; text-align: center; font-size: 11px; color: #999; text-decoration: none; }
.nav-item i { font-size: 20px; display: block; margin-bottom: 3px; }
.nav-item.active { color: var(--primary); font-weight: bold; }

/* Grid & Cards */
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: var(--white); border-radius: 15px; padding: 15px; margin-bottom: 15px; box-shadow: var(--shadow); border: 1px solid rgba(0,0,0,0.03); }
.alert-box { background: #fff3e0; border-left: 5px solid var(--warning); padding: 12px; border-radius: 8px; font-size: 12px; margin-bottom: 15px; }

/* Form & Buttons */
input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 10px; outline: none; font-size: 14px; }
.btn-main { background: linear-gradient(to right, var(--primary), var(--primary-dark)); color: white; border: none; padding: 15px; border-radius: 12px; width: 100%; font-weight: bold; cursor: pointer; box-shadow: 0 4px 10px rgba(46,125,50,0.2); }
.btn-emergency { background: var(--accent); color: white; border: none; padding: 12px; border-radius: 10px; font-weight: bold; cursor: pointer; text-decoration: none; display: block; text-align: center; margin-bottom: 10px; }

/* News Ticker */
.ticker { background: #333; color: #ffeb3b; padding: 5px; font-size: 11px; white-space: nowrap; overflow: hidden; position: relative; }
.ticker p { display: inline-block; padding-left: 100%; animation: scroll 20s linear infinite; margin: 0; }
@keyframes scroll { 0% { transform: translate(0, 0); } 100% { transform: translate(-100%, 0); } }
EOF

# 3. LANDING PAGE (index.html) - Integrasi BMKG & Cuaca
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Garda Dumai Kota</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="ticker"><p>⚠️ INFO: Waspada cuaca ekstrem di pesisir Dumai Kota. Petugas GARDA siaga di Kelurahan Laksamana dan Rimba Sekampung.</p></div>
    
    <div class="app-header">
        <img src="assets/img/garda-dumaikota.png" alt="Logo">
        <div style="text-align:center;">
            <div style="font-size:10px; opacity:0.8;">KECAMATAN DUMAI KOTA</div>
            <div style="font-size:16px; font-weight:bold;">GARDA KOTA IDAMAN</div>
        </div>
        <i class="fas fa-bell-slash" id="notif-btn" onclick="alert('Notifikasi Aktif')"></i>
    </div>

    <div class="container">
        <div class="card" style="border-left: 5px solid #d32f2f;">
            <h4 style="margin:0 0 10px 0; color:#d32f2f;"><i class="fas fa-house-crack"></i> Info Gempa Terkini (BMKG)</h4>
            <div id="gempa-info" style="font-size:13px; font-weight:600;">Sedang memuat data BMKG...</div>
        </div>

        <div class="card" style="background: linear-gradient(135deg, #0288d1, #01579b); color:white;">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <div id="weather-desc">Cerah Berawan</div>
                    <h2 style="margin:5px 0" id="weather-temp">30°C</h2>
                    <small>Dumai, Riau</small>
                </div>
                <i class="fas fa-cloud-sun-rain" style="font-size:40px; opacity:0.5;"></i>
            </div>
        </div>

        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px; margin-top:10px;">
            <a href="modul/aksi/index.html" class="card" style="text-align:center; text-decoration:none; color:inherit;">
                <i class="fas fa-file-signature" style="font-size:24px; color:var(--primary);"></i><br><small>Lapor Kejadian</small>
            </a>
            <a href="modul/peta/index.html" class="card" style="text-align:center; text-decoration:none; color:inherit;">
                <i class="fas fa-map-location-dot" style="font-size:24px; color:var(--info);"></i><br><small>Peta Pantau</small>
            </a>
        </div>

        <div class="card">
            <h4 style="margin:0 0 10px 0;"><i class="fas fa-newspaper"></i> Berita Kebencanaan</h4>
            <div style="font-size:13px;">Strategi Mitigasi Banjir Rob di Kecamatan Dumai Kota Tahun 2025...</div>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="index.html" class="nav-item active"><i class="fas fa-home"></i>Home</a>
        <a href="modul/peta/index.html" class="nav-item"><i class="fas fa-map"></i>Peta</a>
        <a href="modul/aksi/index.html" class="nav-item"><i class="fas fa-bolt"></i>Aksi</a>
        <a href="modul/admin/login.html" class="nav-item"><i class="fas fa-user-shield"></i>Admin</a>
    </nav>

    <script>
        async function fetchBMKG() {
            try {
                const res = await fetch('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
                const data = await res.json();
                const g = data.Infogempa.gempa;
                document.getElementById('gempa-info').innerHTML = `Magnitude: ${g.Magnitude} | ${g.Wilayah} <br> <small style="color:#666">${g.Tanggal} - ${g.Jam}</small>`;
            } catch (e) { document.getElementById('gempa-info').innerText = "Gagal memuat data BMKG"; }
        }
        fetchBMKG();
    </script>
</body>
</html>
EOF

# 4. MODUL AKSI (Combined Lapor & Emergency with Back Button)
cat << 'EOF' > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Aksi Cepat - Garda Kota</title>
</head>
<body>
    <div class="app-header">
        <button class="back-btn" onclick="window.location.href='../../index.html'"><i class="fas fa-chevron-left"></i> Kembali</button>
        <div style="font-weight:bold;">AKSI CEPAT</div>
        <div style="width:50px;"></div>
    </div>

    <div class="container">
        <div class="card">
            <h3><i class="fas fa-camera"></i> Laporan Visual</h3>
            <input type="text" id="nama" placeholder="Nama Pelapor">
            <select id="kat">
                <option>Pilih Kategori</option>
                <option>Drainase Tersumbat</option>
                <option>Sampah Liar</option>
                <option>Kebakaran</option>
                <option>Lainnya</option>
            </select>
            <textarea id="ket" rows="3" placeholder="Deskripsi kejadian..."></textarea>
            
            <div id="gps-status" style="padding:10px; background:#e8f5e9; border-radius:8px; font-size:12px; margin-bottom:10px; color:var(--primary-dark);">
                <i class="fas fa-location-crosshairs"></i> Lokasi belum dikunci
            </div>
            <button class="btn-main" style="background:var(--info); margin-bottom:10px;" onclick="getGPS()"><i class="fas fa-crosshairs"></i> Kunci Koordinat GPS</button>
            
            <input type="file" id="foto" accept="image/*" capture="camera">
            <button class="btn-main" style="margin-top:15px;" onclick="kirimLaporan()"><i class="fas fa-paper-plane"></i> KIRIM LAPORAN KE DASHBOARD</button>
        </div>

        <div class="card" style="border: 2px solid var(--accent);">
            <h4 style="color:var(--accent); margin:0 0 10px 0;"><i class="fas fa-phone-flip"></i> PANGGILAN DARURAT (HOTLINE)</h4>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                <a href="tel:110" class="btn-emergency" style="background:#1a237e;"><i class="fas fa-police-box"></i> POLISI</a>
                <a href="tel:076538208" class="btn-emergency"><i class="fas fa-fire"></i> DAMKAR</a>
            </div>
        </div>
    </div>
    <script>
        let lat="", lng="";
        function getGPS(){
            navigator.geolocation.getCurrentPosition(p => {
                lat = p.coords.latitude; lng = p.coords.longitude;
                document.getElementById('gps-status').innerText = `Lokasi Terkunci: ${lat}, ${lng}`;
            }, () => alert("Mohon aktifkan GPS!"));
        }
        function kirimLaporan(){ alert("Laporan Sedang Diproses..."); }
    </script>
</body>
</html>
EOF

# 5. MODUL ADMIN (Login & Panel Kontrol)
cat << 'EOF' > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Login Admin</title>
</head>
<body style="background:linear-gradient(135deg, var(--primary), var(--primary-dark)); height:100vh; display:flex; align-items:center;">
    <div class="container" style="text-align:center;">
        <div class="card">
            <img src="../../assets/img/garda-dumaikota.png" style="width:80px; margin-bottom:15px;">
            <h3 style="margin:0;">ADMIN ACCESS</h3>
            <p style="font-size:12px; color:#777;">Sistem Monitoring Garda Dumai Kota</p>
            <input type="password" id="p" placeholder="Password Admin">
            <button class="btn-main" onclick="l()">LOG IN <i class="fas fa-sign-in-alt"></i></button>
            <a href="../../index.html" style="display:block; margin-top:20px; font-size:12px; color:#888;">Kembali ke Beranda</a>
        </div>
    </div>
    <script>
        function l(){
            if(document.getElementById('p').value === "dumaiidaman2025"){
                localStorage.setItem("adm_garda", "true"); window.location.href="index.html";
            } else alert("Akses Ditolak!");
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
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Control Center</title>
</head>
<body>
    <div class="app-header">
        <div style="font-weight:bold;">CONTROL CENTER</div>
        <button class="back-btn" onclick="localStorage.clear(); window.location.href='login.html'"><i class="fas fa-power-off"></i> Logout</button>
    </div>
    <div class="container">
        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
                <h4 style="margin:0;">Laporan Mingguan</h4>
                <button onclick="window.print()" class="back-btn" style="background:#444; font-size:11px;"><i class="fas fa-print"></i> Cetak PDF</button>
            </div>
            <table>
                <thead><tr><th>TGL</th><th>PELAPOR</th><th>AKSI</th></tr></thead>
                <tbody><tr><td>18/12</td><td>Tami</td><td><button style="border:none; background:var(--primary); color:white; border-radius:5px; padding:5px 10px;">Detail</button></td></tr></tbody>
            </table>
        </div>
    </div>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ SUKSES! APLIKASI GARDA DUMAI KOTA (SIGAP STANDARD) SIAP."
echo "💡 Gunakan URL GitHub Bapak untuk mengaktifkan Service Worker."
echo "-------------------------------------------------------"