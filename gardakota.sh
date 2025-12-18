#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "🔧 MEMPERBAIKI MODUL OPERATOR (DASHBOARD & FORM)..."

# 1. FIX CSS GLOBAL (Agar Navigasi Tidak Menutup Konten)
cat << 'EOF' > css/style.css
:root { --primary: #0066FF; --dark: #001a4d; --bg: #f4f7f6; --h: 60px; --nav: 70px; }
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
body { 
    font-family: 'Segoe UI', Roboto, sans-serif; margin: 0; background: var(--bg); 
    padding-top: calc(var(--h) + 10px); 
    padding-bottom: calc(var(--nav) + 30px); /* Tambah ruang agar tidak tertutup nav */
}
.app-header { 
    height: var(--h); background: var(--dark); color: white; 
    display: flex; align-items: center; justify-content: space-between; 
    padding: 0 20px; position: fixed; top: 0; width: 100%; z-index: 2000; 
    box-shadow: 0 2px 10px rgba(0,0,0,0.2); 
}
.app-header h1 { font-size: 14px; margin: 0; text-transform: uppercase; font-weight: 800; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 15px; padding: 20px; margin-bottom: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
.btn-main { 
    height: 50px; display: flex; align-items: center; justify-content: center; 
    background: var(--primary); color: white; border: none; border-radius: 12px; 
    width: 100%; font-weight: 700; text-decoration: none; cursor: pointer; font-size: 15px;
}
.bottom-nav { 
    height: var(--nav); position: fixed; bottom: 0; width: 100%; 
    background: white; display: flex; border-top: 1px solid #eee; z-index: 2000; 
}
.nav-item { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #aaa; text-decoration: none; font-size: 10px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
.nav-item i { font-size: 22px; margin-bottom: 3px; }
label { font-size: 11px; font-weight: 800; color: var(--dark); display: block; margin-top: 15px; margin-bottom: 5px; text-transform: uppercase; }
input, select, textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 10px; background: #fafafa; font-size: 14px; }
EOF

# 2. FIX MODUL OPERATOR (INDEX.HTML) - KATEGORI LENGKAP
cat << 'EOF' > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Lapor - Garda Dumai Kota</title>
</head>
<body>
    <div class="app-header">
        <h1>PANEL OPERATOR</h1>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>

    <div class="container">
        <div class="card" style="background: #e3f2fd; border-left: 5px solid #0066FF;">
            <small style="color: #0066FF; font-weight: bold;">PETUGAS AKTIF:</small>
            <h4 id="op-name" style="margin: 5px 0 0 0; color: #001a4d;">-</h4>
        </div>

        <div class="card">
            <label>I. LOKASI KEJADIAN (GPS)</label>
            <div id="gps-box" style="padding:15px; background:#f5f5f5; border: 2px dashed #ccc; border-radius:10px; text-align:center; font-size:12px; margin-bottom:10px; font-weight:bold;">📍 Belum Mengunci Titik</div>
            <button class="btn-main" onclick="trackGPS()" style="background:#333; height: 40px;"><i class="fas fa-crosshairs"></i>&nbsp; KUNCI GPS</button>
            
            <label>II. JENIS KEJADIAN</label>
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

            <label>III. DETAIL KETERANGAN</label>
            <textarea id="ket" rows="3" placeholder="Sebutkan patokan lokasi & kondisi..."></textarea>

            <label>IV. FOTO BUKTI LAPANGAN</label>
            <input type="file" id="foto" accept="image/*" capture="camera">

            <button class="btn-main" id="btnLapor" onclick="kirim()" style="margin-top:20px;">
                <i class="fas fa-paper-plane"></i>&nbsp; KIRIM LAPORAN SEKARANG
            </button>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-house"></i></a>
        <a href="../peta/index.html" class="nav-item"><i class="fas fa-map"></i></a>
        <a href="#" class="nav-item active"><i class="fas fa-plus-circle"></i></a>
    </nav>

    <script src="operator.js"></script>
</body>
</html>
EOF

# 3. FIX MODUL OPERATOR (OPERATOR.JS) - VALID MAPS URL
cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";

const label = localStorage.getItem("user_label");
if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";

function trackGPS() {
    const box = document.getElementById('gps-box');
    box.innerText = "⌛ Menghubungkan Satelit...";
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        box.innerHTML = "✅ LOKASI TERKUNCI";
        box.style.background = "#e8f5e9"; box.style.color = "#2e7d32"; box.style.borderColor = "#2e7d32";
    }, () => alert("Gagal! Aktifkan GPS HP Anda."), {enableHighAccuracy: true});
}

async function kirim() {
    const file = document.getElementById('foto').files[0];
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !lng) return alert("Bapak belum mengunci LOKASI GPS!");
    if(!file) return alert("Foto bukti wajib dilampirkan!");
    if(!ket) return alert("Mohon isi keterangan kejadian!");

    btn.innerText = "⌛ SEDANG MENGIRIM..."; btn.disabled = true;

    try {
        let fd = new FormData(); fd.append("image", file);
        let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
        let dI = await rI.json();
        
        // --- FIX LINK MAPS: Menggunakan Google Maps Standard ---
        const mapsUrl = "https://www.google.com/maps/search/?api=1&query=" + lat + "," + lng;

        await fetch(SAKTI, { 
            method:'POST', mode:'no-cors', 
            body: JSON.stringify({ 
                nama: label, 
                kategori: document.getElementById('kat').value, 
                keterangan: ket, 
                lokasi: mapsUrl, 
                foto: dI.data.url 
            }) 
        });

        alert("Berhasil! Laporan sudah masuk ke Dashboard Camat.");
        window.location.reload();
    } catch(e) {
        alert("Gangguan Koneksi!");
        btn.innerText = "🚀 KIRIM LAPORAN SEKARANG"; btn.disabled = false;
    }
}
EOF

echo "✅ MODUL OPERATOR BERHASIL DIPERBAIKI."