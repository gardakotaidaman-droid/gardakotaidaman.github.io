#!/bin/bash

echo "🧹 MEMBERSIHKAN SISA-SISA CSS LAMA AGAR SERAGAM..."

# 1. HAPUS FILE CSS LOKAL (YANG BIKIN RUSAK TAMPILAN)
rm -f modul/admin/admin.css
rm -f modul/admin/login.css
rm -f modul/operator/operator.css
rm -f modul/aksi/aksi.css
rm -f modul/peta/peta.css

echo "✅ File CSS lokal telah dihapus. Sekarang semua tunduk pada Master CSS."

# 2. UPDATE MODUL ADMIN (TAMPILAN BERSIH)
cat << EOF > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Admin Command Center</title>
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-header">
        <h1>COMMAND CENTER</h1>
        <a href="../../index.html" class="header-icon"><i class="fas fa-sign-out-alt"></i></a>
    </div>

    <div class="container">
        <div id="wf-list">
            <div style="text-align:center; padding:20px; color:#999;">
                <i class="fas fa-circle-notch fa-spin"></i> Memuat Laporan...
            </div>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="../../index.html" class="nav-item"><i class="fas fa-house"></i></a>
        <a href="../peta/index.html" class="nav-item"><i class="fas fa-map"></i></a>
        <a href="index.html" class="nav-item active"><i class="fas fa-shield-alt"></i></a>
    </nav>

    <script src="admin.js"></script>
</body>
</html>
EOF

# 3. UPDATE MODUL OPERATOR (FORMULIR BERSIH)
cat << EOF > modul/operator/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Lapor Kejadian</title>
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-icon"><i class="fas fa-arrow-left"></i></a>
        <h1>LAPOR KEJADIAN</h1>
        <div style="width:20px;"></div>
    </div>

    <div class="container">
        <div class="card">
            <div class="card-title">Lokasi Kejadian</div>
            <button class="btn-main" onclick="track()" style="background:var(--dark); margin-bottom:10px;">
                <i class="fas fa-crosshairs" style="margin-right:8px;"></i> AMBIL TITIK GPS
            </button>
            <p id="gps-msg" style="text-align:center; font-size:12px; color:var(--grey); margin:0;">Wajib dikunci sebelum lapor</p>
        </div>

        <div class="card">
            <div class="card-title">Detail Laporan</div>
            <select id="kat" style="width:100%; padding:15px; border-radius:12px; margin-bottom:15px; border:1px solid #ddd; background:#f9f9f9; font-size:14px;">
                <option>🌊 Banjir Rob</option>
                <option>🔥 Kebakaran</option>
                <option>🗑️ Sampah Menumpuk</option>
                <option>🛣️ Jalan Rusak</option>
                <option>⚖️ Ketertiban Umum</option>
            </select>
            <textarea id="ket" placeholder="Ceritakan kronologi singkat..." style="width:100%; padding:15px; border-radius:12px; height:120px; border:1px solid #ddd; background:#f9f9f9; font-size:14px; margin-bottom:15px;"></textarea>
            
            <div style="background:#f0f2f5; padding:10px; border-radius:10px; text-align:center; margin-bottom:20px;">
                <input type="file" id="foto" capture="camera" style="width:100%;">
            </div>

            <button class="btn-main" id="btnKirim" onclick="lapor()">KIRIM LAPORAN</button>
        </div>
    </div>
    <script src="operator.js"></script>
</body>
</html>
EOF

# 4. UPDATE MODUL AKSI (SOS)
cat << EOF > modul/aksi/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Aksi Cepat</title>
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-header">
        <a href="../../index.html" class="header-icon"><i class="fas fa-arrow-left"></i></a>
        <h1>AKSI CEPAT</h1>
        <div style="width:20px;"></div>
    </div>

    <div class="container">
        <div style="text-align:center; margin:20px 0;">
            <i class="fas fa-shield-cat" style="font-size:60px; color:var(--primary); opacity:0.2;"></i>
            <p style="color:var(--grey); font-size:13px;">Tekan tombol di bawah untuk panggilan darurat.</p>
        </div>

        <a href="tel:112" class="btn-main btn-danger" style="height:70px; font-size:20px; margin-bottom:15px;">
            <i class="fas fa-phone-volume" style="margin-right:15px;"></i> CALL CENTER 112
        </a>
        <a href="https://wa.me/6281234567890" class="btn-main" style="background:#25D366; height:60px; font-size:18px;">
            <i class="fab fa-whatsapp" style="margin-right:15px;"></i> WHATSAPP CAMAT
        </a>
    </div>
</body>
</html>
EOF

echo "-------------------------------------------------------"
echo "✅ CLEANUP SELESAI!"
echo "📍 Semua modul sekarang HANYA menggunakan css/style.css."
echo "📍 Tampilan dijamin seragam 100% (Clean Minimalis)."
echo "-------------------------------------------------------"