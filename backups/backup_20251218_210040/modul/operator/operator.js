const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";

const label = localStorage.getItem("user_label");
const wilayah = localStorage.getItem("user_wilayah");

if(!label) window.location.href="../admin/login.html";

document.getElementById('display-name').innerHTML = "<b>" + label + "</b><br><small>" + (wilayah || "") + "</small>";

let lat = "", lng = "";

function trackLokasi() {
    const box = document.getElementById('gps-status');
    box.innerHTML = "⌛ Mencari Satelit...";
    
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude;
        lng = p.coords.longitude;
        box.innerHTML = "✅ TERKUNCI: " + lat + ", " + lng;
        box.classList.add('gps-locked');
    }, () => {
        alert("Wajib aktifkan GPS!");
        box.innerHTML = "❌ Gagal";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnKirim');

    if(!lat || !lng) return alert("Kunci GPS dulu!");
    if(!file) return alert("Foto wajib!");
    if(!ket) return alert("Keterangan wajib!");

    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        // Upload Foto
        let fd = new FormData(); fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        
        // --- INI PERBAIKANNYA PAK ---
        // Link resmi Google Maps (Query)
        let mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng; 
        // ----------------------------

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: ket + " (" + wilayah + ")",
                lokasi: mapsUrl, // Masuk ke spreadsheet sebagai link aktif
                foto: dataImg.data.url
            })
        });

        alert("Laporan Terkirim!");
        window.location.reload();
    } catch(e) {
        alert("Gagal kirim. Cek sinyal.");
        btn.innerText = "ULANGI KIRIM";
        btn.disabled = false;
    }
}