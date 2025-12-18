const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let wilayahInfo = "Lokasi Luar Jangkauan";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Melacak Satelit & Wilayah...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // API Reverse Geocoding (Nominatim)
            const response = await fetch(`https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}`);
            const data = await response.json();
            
            const addr = data.address;
            const kel = addr.village || addr.suburb || addr.neighbourhood || "Kelurahan tdk terdeteksi";
            const kec = addr.city_district || addr.district || "Kecamatan tdk terdeteksi";
            
            wilayahInfo = `${kel}, ${kec}`;
            
            box.innerHTML = `✅ TERKUNCI<br><span style="color:#2e7d32; font-size:14px;">${wilayahInfo}</span><br><small>${lat}, ${lng}</small>`;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.borderColor = "#2e7d32";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Gagal mendeteksi nama wilayah, tapi koordinat didapat.</small>";
            box.style.background = "#e8f5e9";
        }
    }, (err) => {
        alert("GPS ERROR: Mohon izinkan akses lokasi di browser/HP Anda.");
        box.innerText = "❌ Gagal mengunci lokasi";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !lng) return alert("Kunci GPS dulu Pak!");
    if(!file) return alert("Foto bukti wajib!");
    if(!ket) return alert("Keterangan wajib!");

    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); 
        fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        
        // Format Google Maps Link
        const mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: `[${wilayahInfo}] ${ket}`,
                lokasi: mapsUrl,
                foto: dataImg.data.url
            })
        });

        alert("Laporan Berhasil Terkirim!");
        window.location.reload();
    } catch(e) {
        alert("Gagal Kirim! Cek Koneksi.");
        btn.innerText = "🚀 KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
