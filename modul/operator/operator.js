const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let wilayahInfo = "Menunggu GPS...";

async function ambilLokasi() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Analisis Data Wilayah...";
    box.style.background = "#fff3e0";

    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // REQUEST KE OSM (Sesuai Parameter Bapak)
            const response = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&zoom=18&accept-language=id-ID&format=jsonv2`);
            const data = await response.json();
            const addr = data.address;
            
            // --- LOGIKA ADAPTIF (SESUAI BUKTI JSON BAPAK) ---
            
            // 1. Bagian DEPAN (Spesifik)
            // Cek urutan: Village (Teluk Binjai) -> Suburb -> Road (Jln Pemda)
            let bagianDepan = addr.village || addr.suburb || addr.neighbourhood || addr.road || "Lokasi";
            
            // 2. Bagian BELAKANG (Admin)
            // Cek urutan: City_District (Dumai Timur) -> District -> City (Dumai)
            // Di JSON Teluk Binjai, ini akan jatuh ke 'addr.city' karena 'city_district' null.
            let bagianBelakang = addr.city_district || addr.district || addr.city || "Dumai";

            // 3. PEMBERIAN LABEL (PREFIX)
            let labelDepan = "";
            if (addr.village || addr.suburb) {
                labelDepan = "Kel. ";
            } else if (addr.road) {
                labelDepan = "Jln. ";
            }

            // GABUNGKAN
            wilayahInfo = `${labelDepan}${bagianDepan}, ${bagianBelakang}`;
            
            box.innerHTML = `✅ TERKUNCI<br><span style="color:#2e7d32; font-size:16px; font-weight:800;">${wilayahInfo}</span><br><small style="color:#666;">${lat}, ${lng}</small>`;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            box.style.borderColor = "#2e7d32";
            
        } catch (err) {
            box.innerHTML = "✅ TERKUNCI<br><small>Koneksi lambat (Koordinat Aman)</small>";
        }
    }, (err) => {
        alert("GPS ERROR: Wajib izinkan lokasi!");
        box.innerText = "❌ GPS Mati";
    }, { enableHighAccuracy: true });
}

async function kirimLaporan() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !file) return alert("Foto & GPS Wajib!");
    btn.innerText = "⏳ MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        
        // Google Maps Link Query (Lebih kompatibel di HP)
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

        alert("Laporan Masuk!");
        window.location.reload();
    } catch(e) {
        alert("Gagal Kirim!");
        btn.innerText = "KIRIM KE DASHBOARD";
        btn.disabled = false;
    }
}
