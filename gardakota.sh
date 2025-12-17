#!/bin/bash

echo "🚨 MENYISIPKAN TOMBOL HOME DI SELURUH MODUL GARDA DUMAI KOTA..."

# 1. FIX HEADER MODUL ADMIN
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
        <a href="../../index.html" style="color:white;"><i class="fas fa-house-chimney"></i></a>
        <div style="font-weight:bold;">COMMAND CENTER</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='login.html'"></i>
    </div>
    <div class="container">
        <div class="card">
            <h4><i class="fas fa-fingerprint"></i> Log Aktivitas</h4>
            <div id="log-list" style="max-height:100px; overflow-y:auto; font-size:11px;">Memuat...</div>
        </div>
        <div id="wf-list">Memuat laporan...</div>
    </div>
    <script src="admin.js"></script>
</body>
</html>
EOF

# 2. FIX HEADER MODUL AKSI
cat << 'EOF' > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Darurat</title>
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-house-chimney"></i></a>
        <div style="font-weight:bold;">AKSI DARURAT</div>
        <div style="width:20px;"></div>
    </div>
    <div class="container">
        <div class="card" style="text-align:center;">
            <div onclick="sos()" style="background:#d32f2f; width:100px; height:100px; border-radius:50%; margin:auto; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold; cursor:pointer;">SOS</div>
            <p id="gps-status" style="font-size:11px; margin-top:10px;">Melacak GPS...</p>
        </div>
        <div class="card">
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                <a href="tel:110" class="btn-main" style="background:#0d47a1; font-size:12px;">POLISI</a>
                <a href="tel:076538208" class="btn-main" style="background:#b71c1c; font-size:12px;">DAMKAR</a>
                <a href="tel:076538208" class="btn-main" style="background:#ef6c00; font-size:12px;">BPBD</a>
                <a href="https://wa.me/6285172206884" class="btn-main" style="background:#2e7d32; font-size:12px;">WA CAMAT</a>
            </div>
        </div>
    </div>
    <script src="aksi.js"></script>
</body>
</html>
EOF

# 3. FIX HEADER MODUL OPERATOR (DENGAN 11 JENIS KEJADIAN)
cat << 'EOF' > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" style="color:white;"><i class="fas fa-house-chimney"></i></a>
        <div style="font-weight:bold;">OPERATOR PANEL</div>
        <i class="fas fa-power-off" onclick="localStorage.clear(); location.href='../admin/login.html'"></i>
    </div>
    <div class="container">
        <div class="card" style="background:#e8f5e9; border-left:5px solid #2e7d32;">
            <small>Petugas:</small> <h4 id="op-name" style="margin:0;">-</h4>
        </div>
        <div class="card">
            <button class="btn-main" onclick="track()"><i class="fas fa-crosshairs"></i> KUNCI LOKASI GPS</button>
            <p id="gps-msg" style="text-align:center; font-size:11px; margin:5px 0;">GPS belum dikunci</p>
            <div id="map-preview" style="height:150px; width:100%; border-radius:12px; display:none; border:2px solid #0d47a1; margin-top:10px;"></div>
            <hr>
            <select id="kat">
                <option value="Banjir Rob / Pasang Keling">🌊 Banjir Rob / Pasang Keling</option>
                <option value="Drainase Tersumbat / Banjir">🕳️ Drainase Tersumbat / Banjir</option>
                <option value="Penumpukan Sampah">🗑️ Penumpukan Sampah</option>
                <option value="Kamtibmas / Tawuran">👮 Kamtibmas / Tawuran</option>
                <option value="Kebakaran Lahan / Karhutla">🔥 Kebakaran Lahan / Karhutla</option>
                <option value="Lampu Jalan Mati (PJU)">💡 Lampu Jalan Mati (PJU)</option>
                <option value="Infrastruktur / Jalan Rusak">🛣️ Infrastruktur / Jalan Rusak</option>
                <option value="Pohon Tumbang / Gangguan Kabel">🌳 Pohon Tumbang</option>
                <option value="Penertiban PKL / Perda">🏪 Penertiban PKL / Perda</option>
                <option value="Layanan Publik / Administrasi">📄 Layanan Publik / Administrasi</option>
                <option value="Lainnya">❓ Kejadian Lainnya</option>
            </select>
            <textarea id="ket" placeholder="Keterangan kejadian..."></textarea>
            <input type="file" id="foto" capture="camera">
            <button class="btn-main" id="btnKirim" onclick="lapor()">🚀 KIRIM LAPORAN SEKARANG</button>
        </div>
    </div>
    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-house"></i>Home</a>
        <a href="../peta/index.html" class="nav-item"><i class="fas fa-map-location-dot"></i>Peta</a>
        <a href="index.html" class="nav-item active"><i class="fas fa-edit"></i>Lapor</a>
    </nav>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="operator.js"></script>
</body>
</html>
EOF

echo "------------------------------------------------------------"
echo "✅ TOMBOL HOME TELAH DIPASANG DI SEMUA MODUL!"
echo "📍 Silakan Upload Perubahan ini ke GitHub Bapak."
echo "------------------------------------------------------------"