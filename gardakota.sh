#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"
IMG_LOGO="https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_Kota_Dumai.png"
TS=$(date +%Y%m%d_%H%M%S)

echo "🛡️ MEMULAI UPDATE AMAN GARDA DUMAI KOTA..."

# 1. SISTEM BACKUP (MENGHINDARI RESIKO KEHILANGAN DATA)
echo "📦 Membuat backup folder lama ke: backup_$TS..."
mkdir -p "backups/backup_$TS"
[ -d "modul" ] && mv modul "backups/backup_$TS/"
[ -d "css" ] && mv css "backups/backup_$TS/"

# 2. REBUILD FOLDER BARU
mkdir -p css modul/admin modul/aksi modul/operator modul/peta

# 3. MASTER CSS (Kunci Standar Visual)
cat << 'EOF' > css/style.css
:root { --primary: #0066FF; --dark: #001a4d; --bg: #f8f9fa; --h: 60px; --nav: 70px; }
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-top: var(--h); padding-bottom: var(--nav); }
.app-header { height: var(--h); background: white; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; position: fixed; top: 0; width: 100%; z-index: 2000; box-shadow: 0 1px 5px rgba(0,0,0,0.1); border-bottom: 2px solid var(--primary); }
.app-header h1 { font-size: 14px; font-weight: 800; color: var(--dark); margin: 0; text-transform: uppercase; }
.container { padding: 15px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 12px; padding: 15px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
.btn-main { height: 48px; display: flex; align-items: center; justify-content: center; background: var(--primary); color: white; border: none; border-radius: 10px; width: 100%; font-weight: 700; text-decoration: none; cursor: pointer; }
.bottom-nav { height: var(--nav); position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #eee; z-index: 2000; }
.nav-item { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #aaa; text-decoration: none; font-size: 10px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
input, select, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; }
EOF

# 4. LOGIN.HTML (Logika Akun Muspika & Kelurahan Sesuai Instruksi)
cat << EOF > modul/admin/login.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/style.css">
    <title>Login Petugas</title>
</head>
<body style="display:flex; align-items:center; justify-content:center; height:100vh; background:#eef2f5;">
    <div class="card" style="width:100%; max-width:340px; text-align:center;">
        <img src="$IMG_LOGO" width="60" style="margin-bottom:15px;">
        <h3 style="margin:0; color:var(--dark);">GARDA DUMAI KOTA</h3>
        <p style="font-size:11px; color:#666; margin-bottom:20px;">Sistem Komando Terpadu</p>
        <input type="text" id="user" placeholder="Username / Jabatan">
        <input type="password" id="pass" placeholder="Password">
        <button class="btn-main" onclick="auth()">MASUK</button>
        <p id="err" style="color:red; font-size:11px; margin-top:10px; display:none;">Akses Ditolak: User/Pass Salah!</p>
    </div>
    <script>
        function auth() {
            const u = document.getElementById('user').value.toLowerCase();
            const p = document.getElementById('pass').value;
            
            // DAFTAR SESUAI INSTRUKSI BAPAK
            const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil", "binmas", "ramil01"];
            const kels = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
            const roles = ["lurah", "babinsa", "bhabin", "trantibkel", "pamong"];
            
            let role = "", label = "";
            
            if(admins.includes(u) && p === "dksiaga") { 
                role="admin"; label=u.toUpperCase(); 
            } else {
                kels.forEach(k => {
                    roles.forEach(r => {
                        if(u === \`\${r}-\${k}\` && p === "pantaudk") {
                            role="operator"; label=u.toUpperCase().replace("-"," ");
                        }
                    });
                });
            }

            if(role) {
                localStorage.setItem("role", role); localStorage.setItem("user_label", label);
                window.location.href = role === "admin" ? "index.html" : "../operator/index.html";
            } else { document.getElementById('err').style.display='block'; }
        }
    </script>
</body>
</html>
EOF

# 5. OPERATOR.JS (Link Maps Resmi - Query Based)
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
        box.innerHTML = "✅ GPS TERKUNCI";
        box.style.background = "#e8f5e9";
    }, () => alert("GPS Gagal!"));
}

async function kirim() {
    const file = document.getElementById('foto').files[0];
    const ket = document.getElementById('ket').value;
    if(!file || !lat || !ket) return alert("Foto, GPS, & Keterangan Wajib!");
    
    document.getElementById('btnLapor').innerText = "⌛ Mengirim...";
    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();
    
    // LINK MAPS RESMI (BUKAN CACHE GOOGLEUSERCONTENT)
    const mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng;

    await fetch(SAKTI, { 
        method:'POST', mode:'no-cors', 
        body: JSON.stringify({ 
            nama: label, kategori: document.getElementById('kat').value, 
            keterangan: ket, lokasi: mapsUrl, foto: dI.data.url 
        }) 
    });
    alert("Laporan Terkirim!"); window.location.reload();
}
EOF

echo "✅ UPDATE SELESAI DENGAN AMAN."
echo "📍 Data lama ada di folder backups/backup_$TS"