const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let wilayahInfo = "Dumai Kota";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Mendeteksi Kelurahan Dumai...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // Pemanggilan dengan Zoom 17 & accept-language sesuai link referensi Bapak
            const response = await fetch(`https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}&zoom=17&addressdetails=1&accept-language=id`);
            const data = await response.json();
            
            const addr = data.address;
            
            // SESUAI DATA NOMINATIM DUMAI:
            // suburb = Kelurahan (Contoh: Rimba Sekampung)
            // city_district = Kecamatan (Contoh: Dumai Kota)
            const kel = addr.suburb || addr.village || addr.neighbourhood || "Kelurahan tdk terdeteksi";
            const kec = addr.city_district || addr.district || "Kecamatan tdk terdeteksi";
            
            wilayahInfo = `Kel. ${kel}, ${kec}`;
            
            box.innerHTML = `✅ TERKUNCI<br><span style="color:#2e7d32; font-size:16px; font-weight:800;">${wilayahInfo}</span><br><small style="color:#666;">${lat}, ${lng}</small>`;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.border = "2px solid #2e7d32";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Gagal memuat nama wilayah (Timeout/Sinyal)</small>";
        }
    }, (err) => {
        alert("Gagal melacak GPS!");
        box.innerText = "❌ GPS Error";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !file) return alert("Wajib Kunci GPS & Ambil Foto!");
    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
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

        alert("Berhasil!");
        window.location.reload();
    } catch(e) {
        alert("Gagal!");
        btn.innerText = "KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
