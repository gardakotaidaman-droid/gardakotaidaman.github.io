#!/bin/bash

URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"

echo "💎 MEMBANGUN ULANG GARDA DUMAI KOTA V3 - STANDAR KOMANDO..."

# 1. CSS GLOBAL (Pusat Kendali Visual)
cat << 'EOF' > css/style.css
:root { --primary: #002171; --accent: #d32f2f; --bg: #f4f7f6; --h: 65px; --nav: 70px; }
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; font-family: 'Segoe UI', sans-serif; }
body { margin: 0; background: var(--bg); padding-top: var(--h); padding-bottom: var(--nav); font-size: 14px; }
.app-header { height: var(--h); background: var(--primary); color: white; display: flex; align-items: center; justify-content: space-between; padding: 0 15px; position: fixed; top: 0; width: 100%; z-index: 2000; border-bottom: 3px solid #ffeb3b; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
.container { padding: 12px; max-width: 500px; margin: auto; }
.card { background: white; border-radius: 12px; padding: 16px; margin-bottom: 12px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
.btn-main { height: 48px; display: flex; align-items: center; justify-content: center; background: var(--primary); color: white; border: none; border-radius: 10px; width: 100%; font-weight: 600; text-decoration: none; cursor: pointer; }
.bottom-nav { height: var(--nav); position: fixed; bottom: 0; width: 100%; background: white; display: flex; border-top: 1px solid #ddd; z-index: 2000; }
.nav-item { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #888; text-decoration: none; font-size: 10px; }
.nav-item.active { color: var(--primary); font-weight: bold; }
.nav-item i { font-size: 20px; margin-bottom: 3px; }
EOF

# 2. OPERATOR JS (Perbaikan URL Maps)
cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "2e07237050e6690770451ded20f761b5";
let lat = "", lng = "";

function track() {
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        document.getElementById('gps-msg').innerHTML = "✅ GPS TERKUNCI";
        document.getElementById('gps-msg').style.color = "green";
    });
}

async function lapor() {
    if(!lat) return alert("Kunci GPS dulu!");
    const file = document.getElementById('foto').files[0];
    if(!file) return alert("Foto wajib!");
    
    document.getElementById('btnKirim').innerText = "⌛ MENGIRIM...";
    
    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();

    const linkMaps = "https://www.google.com/maps/search/?api=1&query=" + lat + "," + lng;

    await fetch(SAKTI, {
        method:'POST', mode:'no-cors',
        body: JSON.stringify({ 
            nama: localStorage.getItem("user_label"),
            kategori: document.getElementById('kat').value,
            keterangan: document.getElementById('ket').value,
            lokasi: linkMaps,
            foto: dI.data.url
        })
    });
    alert("Laporan Terkirim!"); location.reload();
}
EOF

# 3. ADMIN JS (Perbaikan Jarak & URL Maps)
cat << EOF > modul/admin/admin.js
const SAKTI = "$URL_SAKTI";
let aLat, aLng;

navigator.geolocation.getCurrentPosition(p => {
    aLat = p.coords.latitude; aLng = p.coords.longitude;
    loadAdmin();
}, () => loadAdmin());

function calcDist(lat2, lon2) {
    if(!aLat) return "";
    const R = 6371;
    const dLat = (lat2-aLat) * Math.PI / 180;
    const dLon = (lon2-aLng) * Math.PI / 180;
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(aLat * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLon/2) * Math.sin(dLon/2);
    const d = R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return \`📍 \${d.toFixed(1)} km (\${Math.round(d*4)} mnt)\`;
}

async function loadAdmin() {
    const r = await fetch(SAKTI);
    const d = await r.json();
    let h = "";
    d.laporan.reverse().forEach((i, idx) => {
        if(idx === d.laporan.length - 1 || !i[0]) return;
        let dist = "";
        const m = i[4].match(/query=(-?\\d+\\.\\d+),(-?\\d+\\.\\d+)/);
        if(m) dist = calcDist(parseFloat(m[1]), parseFloat(m[2]));

        h += \`<div class="card">
            <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                <small><b>\${i[1]}</b> • \${i[2]}</small>
                <b style="font-size:10px; color:#d32f2f;">\${dist}</b>
            </div>
            <p style="font-size:13px; color:#444; margin:5px 0;">\${i[3]}</p>
            <div style="display:flex; gap:8px; margin-top:12px;">
                <a href="\${i[4]}" target="_blank" class="btn-main" style="background:#eee; color:#333; flex:1; height:35px; font-size:11px;">MAPS</a>
                <a href="\${i[5]}" target="_blank" class="btn-main" style="background:#eee; color:#333; flex:1; height:35px; font-size:11px;">FOTO</a>
                <button onclick="upd('\${i[0]}','Selesai')" class="btn-main" style="background:#2ecc71; flex:1; height:35px; font-size:11px;">DONE</button>
            </div>
        </div>\`;
    });
    document.getElementById('wf-list').innerHTML = h;
}

async function upd(id, st) {
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:id, status:st }) });
    location.reload();
}
loadAdmin();
EOF

echo "-------------------------------------------------------"
echo "✅ BERES PAK TAMY! URL Maps diperbaiki, UX Diseragamkan."
echo "-------------------------------------------------------"