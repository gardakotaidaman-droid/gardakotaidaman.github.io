const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
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
