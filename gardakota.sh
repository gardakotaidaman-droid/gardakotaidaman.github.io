#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "🔧 Memperbaiki Sistem Kontrol & Mencegah Error 404 Vercel..."

cat << EOF > modul/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Garda Dumai Kota Command Center</title>
</head>
<body style="background:#f4f7f6; font-family: sans-serif; margin:0;">
    <div class="app-header" style="background:#1a1a1a; color:white; padding:15px 20px; display:flex; justify-content:space-between; align-items:center;">
        <h1 style="font-size:16px; margin:0;">Admin TRC | Halo, <span id="admin-nick"></span></h1>
        <button type="button" onclick="localStorage.clear(); location.href='login.html';" style="background:#c0392b; color:white; border:none; padding:8px 15px; border-radius:5px; cursor:pointer;">Keluar</button>
    </div>

    <div style="padding: 20px; max-width: 1200px; margin: auto;">
        <div style="margin-bottom: 25px; border-bottom: 3px solid #1a1a1a; padding-bottom: 10px; display:flex; justify-content:space-between; align-items:center;">
            <h2 style="font-size:20px; color:#1a1a1a; margin:0; font-weight:800;">GARDA DUMAI KOTA COMMAND CENTER</h2>
            <span style="background:#e74c3c; color:white; padding:5px 15px; border-radius:20px; font-size:16px; font-weight:bold;" id="total-lap">0</span>
        </div>

        <div style="background: white; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); overflow-x: auto;">
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
                <tbody id="table-body">
                    </tbody>
            </table>
        </div>
    </div>

    <script src="../aksi/auth.js"></script>
    <script>
        // Jalankan satpam halaman
        if(typeof proteksiHalaman === 'function') proteksiHalaman('admin');
        document.getElementById('admin-nick').innerText = localStorage.getItem('user_label') || "ADMIN";

        const SAKTI = "$URL_SAKTI";

        // FUNGSI: UPDATE STATUS
        async function updateStatus(rowId, status) {
            if(!confirm("Ubah status laporan ke " + status + "?")) return;
            
            // Gunakan mode no-cors untuk kirim perintah ke Google Apps Script
            const urlAction = \`\${SAKTI}?action=update&id=\${rowId}&status=\${status}\`;
            
            try {
                // Fetch tanpa pindah halaman (AJAX)
                await fetch(urlAction, { method: 'POST', mode: 'no-cors' });
                alert("Status " + status + " Berhasil Dikirim!");
                
                // Refresh data setelah 2 detik agar Google Sheets sempat memproses
                setTimeout(loadLaporan, 2000);
            } catch(e) {
                alert("Gagal koneksi!");
            }
        }

        // FUNGSI: HAPUS DATA
        async function hapusLaporan(rowId) {
            if(!confirm("⚠️ Hapus laporan ini secara permanen dari database?")) return;
            
            const urlAction = \`\${SAKTI}?action=delete&id=\${rowId}\`;
            
            try {
                await fetch(urlAction, { method: 'POST', mode: 'no-cors' });
                alert("Laporan Terhapus!");
                setTimeout(loadLaporan, 2000);
            } catch(e) {
                alert("Gagal menghapus!");
            }
        }

        async function loadLaporan() {
            const tbody = document.getElementById('table-body');
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:50px;">⌛ Menghubungkan ke Command Center...</td></tr>';
            
            try {
                const res = await fetch(SAKTI);
                const data = await res.json();
                const laporans = data.laporan;
                
                document.getElementById('total-lap').innerText = laporans.length;
                tbody.innerHTML = '';

                laporans.reverse().forEach((item, index) => {
                    const rowId = laporans.length - index; // ID baris Google Sheets
                    const status = item[6] || 'Menunggu';
                    const stColor = status === 'Selesai' ? 'background:#d4edda;color:#155724' : (status === 'Proses' ? 'background:#fff3cd;color:#856404' : 'background:#ffdada;color:#c0392b');
                    
                    tbody.innerHTML += \`
                        <tr>
                            <td style="padding:15px; border-bottom:1px solid #eee;">\${item[0]}</td>
                            <td style="padding:15px; border-bottom:1px solid #eee;">
                                <b>\${item[2]}</b><br><small style="color:#777;">Petugas: \${item[1]}</small>
                            </td>
                            <td style="padding:15px; border-bottom:1px solid #eee;">
                                <div style="color:#2e7d32; font-weight:bold;">\${item[4]}</div>
                            </td>
                            <td style="padding:15px; border-bottom:1px solid #eee;">
                                <span style="padding:5px 12px; border-radius:20px; font-size:11px; font-weight:bold; \${stColor}">\${status}</span>
                            </td>
                            <td style="padding:15px; border-bottom:1px solid #eee;">
                                <button type="button" onclick="window.open('\${item[3]}','_blank')" style="background:#3498db; color:white; border:none; padding:8px; border-radius:5px; cursor:pointer;" title="Buka Maps"><i class="fas fa-map-marked-alt"></i></button>
                                <button type="button" onclick="updateStatus(\${rowId}, 'Proses')" style="background:#f1c40f; color:white; border:none; padding:8px; border-radius:5px; cursor:pointer;" title="Proses Laporan"><i class="fas fa-hard-hat"></i></button>
                                <button type="button" onclick="updateStatus(\${rowId}, 'Selesai')" style="background:#2ecc71; color:white; border:none; padding:8px; border-radius:5px; cursor:pointer;" title="Selesaikan"><i class="fas fa-check-circle"></i></button>
                                <button type="button" onclick="hapusLaporan(\${rowId})" style="background:#e74c3c; color:white; border:none; padding:8px; border-radius:5px; cursor:pointer;" title="Hapus"><i class="fas fa-trash-alt"></i></button>
                            </td>
                        </tr>\`;
                });
            } catch (e) {
                tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:50px;">❌ Gagal memuat data.</td></tr>';
            }
        }

        window.onload = loadLaporan;
    </script>
</body>
</html>
EOF

echo "✅ Update Selesai. Sistem Command Center sekarang kebal dari Error 404 Vercel."