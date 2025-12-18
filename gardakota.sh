#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "🔧 Sinkronisasi Tombol & Display Wilayah..."

# 1. PERBAIKI INDEX.HTML (Pastikan ID dan Onclick Benar)
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
        <a href="../../index.html" class="header-icon" style="color:white; text-decoration:none;"><i class="fas fa-home"></i></a>
        <h1>PANEL OPERATOR</h1>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>

    <div class="container">
        <div class="card" style="background: #e3f2fd; border-left: 5px solid #0066FF;">
            <small style="color: #0066FF; font-weight: bold;">PETUGAS:</small>
            <h4 id="op-name" style="margin: 5px 0 0 0; color: #001a4d;">-</h4>
        </div>

        <div class="card">
            <label>I. LOKASI KEJADIAN (GPS)</label>
            <div id="gps-box" style="padding:15px; background:#f5f5f5; border: 2px dashed #ccc; border-radius:10px; text-align:center; font-size:12px; margin-bottom:10px; font-weight:bold; line-height:1.4;">
                📍 Silakan Kunci Titik Lokasi
            </div>
            <button class="btn-main" onclick="ambilLokasi()" style="background:#333; height: 45px;">
                <i class="fas fa-crosshairs"></i>&nbsp; KUNCI TITIK GPS
            </button>
            
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
            <textarea id="ket" rows="3" placeholder="Contoh: Depan gang posyandu..."></textarea>

            <label>IV. FOTO BUKTI</label>
            <input type="file" id="foto" accept="image/*" capture="camera">

            <button class="btn-main" id="btnLapor" onclick="kirimLaporan()" style="margin-top:20px;">
                <i class="fas fa-paper-plane"></i>&nbsp; KIRIM KE DASHBOARD
            </button>
        </div>
    </div>
    <script src="operator.js"></script>
</body>
</html>
EOF

# 2. PERBAIKI OPERATOR.JS (Logic Reverse Geocoding)
cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let wilayahInfo = "Lokasi Luar Jangkauan";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Melacak Satelit & Wilayah...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // API Reverse Geocoding (Nominatim)
            const response = await fetch(\`https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=\${lat}&lon=\${lng}\`);
            const data = await response.json();
            
            const addr = data.address;
            const kel = addr.village || addr.suburb || addr.neighbourhood || "Kelurahan tdk terdeteksi";
            const kec = addr.city_district || addr.district || "Kecamatan tdk terdeteksi";
            
            wilayahInfo = \`\${kel}, \${kec}\`;
            
            box.innerHTML = \`✅ TERKUNCI<br><span style="color:#2e7d32; font-size:14px;">\${wilayahInfo}</span><br><small>\${lat}, \${lng}</small>\`;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.borderColor = "#2e7d32";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Gagal mendeteksi nama wilayah, tapi koordinat didapat.</small>";
            box.style.background = "#e8f5e9";
        }
    }, (err) => {
        alert("GPS ERROR: Mohon izinkan akses lokasi di browser/HP Anda.");
        box.innerText = "❌ Gagal mengunci lokasi";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !lng) return alert("Kunci GPS dulu Pak!");
    if(!file) return alert("Foto bukti wajib!");
    if(!ket) return alert("Keterangan wajib!");

    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); 
        fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        
        // Format Google Maps Link
        const mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: \`[\${wilayahInfo}] \${ket}\`,
                lokasi: mapsUrl,
                foto: dataImg.data.url
            })
        });

        alert("Laporan Berhasil Terkirim!");
        window.location.reload();
    } catch(e) {
        alert("Gagal Kirim! Cek Koneksi.");
        btn.innerText = "🚀 KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
EOF

echo "✅ Sinkronisasi Selesai. Silakan Coba Klik Lagi."