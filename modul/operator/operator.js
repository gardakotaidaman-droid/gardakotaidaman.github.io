const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";

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
