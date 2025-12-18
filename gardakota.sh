#!/bin/bash

# CONFIG DATA
URL_SAKTI="https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"
IMGBB_KEY="2e07237050e6690770451ded20f761b5"

echo "🔧 Memperbaiki Pemisahan Data Lokasi & Keterangan..."

cat << EOF > modul/operator/operator.js
const SAKTI = "$URL_SAKTI";
const IMGBB = "$IMGBB_KEY";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let infoJalan = "", infoKel = "", infoKec = "";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Mengunci Satelit...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // Triple Fetch Logic (18, 14, 12)
            const r1 = await fetch(\`https://nominatim.openstreetmap.org/reverse?lat=\${lat}&lon=\${lng}&zoom=18&accept-language=id-ID&format=jsonv2\`);
            const d1 = await r1.json();
            const r2 = await fetch(\`https://nominatim.openstreetmap.org/reverse?lat=\${lat}&lon=\${lng}&zoom=14&accept-language=id-ID&format=jsonv2\`);
            const d2 = await r2.json();
            const r3 = await fetch(\`https://nominatim.openstreetmap.org/reverse?lat=\${lat}&lon=\${lng}&zoom=12&accept-language=id-ID&format=jsonv2\`);
            const d3 = await r3.json();

            infoJalan = d1.address.road || d1.address.pedestrian || "Jln. Tidak Terdeteksi";
            infoKel = d2.address.village || d2.address.suburb || d2.address.neighbourhood || "Kelurahan";
            infoKec = d3.address.city_district || d3.address.district || "Kecamatan";

            box.innerHTML = \`✅ TERKUNCI<br><div style="text-align:left; font-size:12px; margin-top:5px; padding-left:10px; border-left:3px solid green;">\${infoJalan}<br><b>Kel. \${infoKel}</b><br>\${infoKec}</div>\`;
            box.style.background = "#e8f5e9";
        } catch (e) { box.innerHTML = "✅ TERKUNCI (GPS OK)"; }
    }, (err) => { alert("Wajib Aktifkan GPS!"); }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !file) return alert("Kunci GPS & Ambil Foto!");
    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dImg = await resImg.json();

        // --- PERBAIKAN DI SINI ---
        // 1. Link Maps MURNI (Hanya lat & lon)
        const mapsUrl = \`https://www.google.com/maps?q=\${lat},\${lng}\`;

        // 2. Keterangan GABUNGAN (Wilayah + Deskripsi)
        const keteranganLengkap = \`[Kel. \${infoKel}, \${infoKec} | \${infoJalan}] \${ket}\`;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: keteranganLengkap,
                lokasi: mapsUrl, // Sekarang isinya link maps asli
                foto: dImg.data.url
            })
        });

        alert("Laporan Terkirim!");
        window.location.reload();
    } catch(e) {
        alert("Gagal Kirim!");
        btn.innerText = "KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
EOF

echo "✅ Berhasil. Sekarang data Lokasi dan Keterangan sudah terpisah dengan benar."