#!/bin/bash

# CONFIG DATA (Sesuai database Bapak)
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🔧 Memperbaiki Sistem Kontrol: GARDA DUMAI KOTA..."

cat << EOF > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota Command Center</title>
    <style>
        /* Tambahan style agar tombol tidak dianggap link */
        button { cursor: pointer; border: none; transition: 0.2s; }
        button:active { transform: scale(0.9); }
    </style>
</head>
<body style="background:#f4f7f6; font-family: sans-serif; margin:0;">
    <div class="app-header" style="background:#1a1a1a; color:white; padding:15px 20px; display:flex; justify-content:space-between; align-items:center;">
        <h1 style="font-size:18px; margin:0;">Admin TRC | Halo, <span id="admin-nick"></span></h1>
        <button onclick="localStorage.clear(); location.href='login.html';" style="background:#c0392b; color:white; padding:8px 15px; border-radius:5px;">Keluar</button>
    </div>

    <div style="padding: 20px; max-width: 1200px; margin: auto;">
        <h2 style="border-bottom:3px solid #1a1a1a; padding-bottom:10px;">GARDA DUMAI KOTA COMMAND CENTER <span id="total-lap" style="float:right; background:#e74c3c; color:white; padding:2px 10px; border-radius:10px;">0</span></h2>
        
        <div style="background: white; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); overflow-x: auto;">
            <table style="width:100%; border-collapse:collapse; min-width:900px;">
                <thead>
                    <tr style="background:#2c3e50; color:white; text-align:left;">
                        <th style="padding:15px;">Waktu</th>
                        <th style="padding:15px;">Jenis</th>
                        <th style="padding:15px;">Lokasi / Wilayah</th>
                        <th style="padding:15px;">Status</th>
                        <th style="padding:15px;">Aksi</th>
                    </tr>
                </thead>
                <tbody id="table-body"></tbody>
            </table>
        </div>
    </div>

    <script src="../aksi/auth.js"></script>
    <script>
        // Jalankan satpam halaman
        if(typeof proteksiHalaman === 'function') proteksiHalaman('admin');
        document.getElementById('admin-nick').innerText = localStorage.getItem('user_label') || "ADMIN";

        const SAKTI = "$URL_SAKTI";

        // FUNGSI UTAMA: Update Status Tanpa Redirect
        async function updateStatus(rowId, newStatus) {
            if(!confirm("Proses laporan ini?")) return;
            
            // Tampilkan loading sementara pada tombol
            console.log("Mengirim perintah ke database...");
            
            const targetUrl = \`\${SAKTI}?action=update&id=\${rowId}&status=\${newStatus}\`;
            
            try {
                // Gunakan image ping untuk bypass CORS limitasi Apps Script yang sering bikin macet
                const img = new Image();
                img.src = targetUrl; 
                
                alert("Perintah '"+newStatus+"' Terkirim! Mohon tunggu 3 detik untuk refresh database.");
                
                // Beri jeda 3 detik agar database Sheets sempat memproses sebelum kita load ulang
                setTimeout(loadLaporan, 3000);
            } catch(e) {
                alert("Gagal terhubung ke pusat data!");
            }
        }

        async function hapusData(rowId) {
            if(!confirm("⚠️ PERINGATAN: Hapus laporan secara permanen?")) return;
            
            const targetUrl = \`\${SAKTI}?action=delete&id=\${rowId}\`;
            
            try {
                const img = new Image();
                img.src = targetUrl;
                alert("Perintah Hapus Terkirim!");
                setTimeout(loadLaporan, 3000);
            } catch(e) {
                alert("Gagal menghapus!");
            }
        }

        async function loadLaporan() {
            const tbody = document.getElementById('table-body');
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:30px;">⌛ Sinkronisasi Data Laporan...</td></tr>';
            
            try {
                const res = await fetch(SAKTI);
                const data = await res.json();
                const laporans = data.laporan;
                document.getElementById('total-lap').innerText = laporans.length;
                tbody.innerHTML = '';

                laporans.reverse().forEach((item, index) => {
                    const realRowIndex = laporans.length - index; 
                    const statusVal = item[6] || 'Menunggu';
                    const stColor = statusVal === 'Selesai' ? 'background:#d4edda;color:#155724' : (statusVal === 'Proses' ? 'background:#fff3cd;color:#856404' : 'background:#ffdada;color:#c0392b');
                    
                    // Gunakan BUTTON murni, hindari tag A agar tidak lari ke 404
                    tbody.innerHTML += \`
                        <tr>
                            <td style="padding:15px; border-bottom:1px solid #eee;">\${item[0]}</td>
                            <td style="padding:15px; border-bottom:1px solid #eee;"><b>\${item[2]}</b><br><small>\${item[1]}</small></td>
                            <td style="padding:15px; border-bottom:1px solid #eee; color:#2e7d32; font-weight:bold; font-size:13px;">\${item[4]}</td>
                            <td style="padding:15px; border-bottom:1px solid #eee;"><span style="padding:5px 10px; border-radius:15px; font-size:11px; font-weight:bold; \${stColor}">\${statusVal}</span></td>
                            <td style="padding:15px; border-bottom:1px solid #eee;">
                                <button type="button" onclick="window.open('\${item[3]}','_blank')" style="background:#3498db; color:white; padding:8px; border-radius:5px;" title="Peta"><i class="fas fa-map"></i></button>
                                <button type="button" onclick="updateStatus(\${realRowIndex}, 'Proses')" style="background:#f1c40f; color:white; padding:8px; border-radius:5px;" title="Proses"><i class="fas fa-hard-hat"></i></button>
                                <button type="button" onclick="updateStatus(\${realRowIndex}, 'Selesai')" style="background:#2ecc71; color:white; padding:8px; border-radius:5px;" title="Selesai"><i class="fas fa-check"></i></button>
                                <button type="button" onclick="hapusData(\${realRowIndex})" style="background:#e74c3c; color:white; padding:8px; border-radius:5px;" title="Hapus"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>\`;
                });
            } catch (e) { tbody.innerHTML = "<tr><td colspan='5' style='text-align:center;'>Gagal memuat data. Periksa URL SAKTI.</td></tr>"; }
        }
        window.onload = loadLaporan;
    </script>
</body>
</html>
EOF

echo "✅ Berhasil. Tombol Admin sekarang menggunakan metode 'Safe-Ping' untuk mencegah 404."