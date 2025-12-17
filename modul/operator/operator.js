const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

document.getElementById('op-name').innerText = label;
let lat = "", lng = "", mapPreview;

function track() {
    const msg = document.getElementById('gps-msg');
    const mapDiv = document.getElementById('map-preview');
    msg.innerText = "⌛ Menghubungkan Satelit...";

    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        msg.innerHTML = "✅ KOORDINAT TERKUNCI";
        msg.style.color = "green";

        // Tampilkan Peta Otomatis
        mapDiv.style.display = "block";
        if (!mapPreview) {
            mapPreview = L.map('map-preview').setView([lat, lng], 17);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mapPreview);
        } else {
            mapPreview.setView([lat, lng], 17);
        }
        L.marker([lat, lng]).addTo(mapPreview);

        // Notifikasi ke Admin (Ping Intelligence)
        fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action: "log", user: label, type: "Melacak Lokasi (Siaga)" }) });
    }, () => alert("Gagal melacak! Aktifkan GPS."));
}

async function lapor() {
    const file = document.getElementById('foto').files[0];
    const btn = document.getElementById('btnKirim');
    if(!file || !lat) return alert("Foto & Kunci GPS Wajib!");

    btn.innerText = "⏳ Mengirim..."; btn.disabled = true;
    try {
        let fd = new FormData(); fd.append("image", file);
        let resI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
        let dI = await resI.json();

        await fetch(SAKTI, {
            method:'POST', mode:'no-cors',
            body: JSON.stringify({ 
                nama: label, 
                kategori: document.getElementById('kat').value, 
                keterangan: document.getElementById('ket').value, 
                lokasi: `https://www.google.com/maps?q=${lat},${lng}`, 
                foto: dI.data.url 
            })
        });
        alert("Laporan Terkirim!"); window.location.reload();
    } catch(e) { alert("Error!"); btn.innerText="🚀 KIRIM"; btn.disabled=false; }
}