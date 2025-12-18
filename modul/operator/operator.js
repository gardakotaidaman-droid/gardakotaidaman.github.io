const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");

if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

let lat = "", lng = "";
let alamatLengkap = "";

async function trackGPS() {
    const box = document.getElementById('gps-box');
    box.innerHTML = "⌛ Mencari Satelit & Mendeteksi Wilayah...";
    box.style.background = "#fff3e0";
    box.style.color = "#e65100";
    
    navigator.geolocation.getCurrentPosition(async (p) => {
        lat = p.coords.latitude; 
        lng = p.coords.longitude;
        
        try {
            // REVERSE GEOCODING UNTUK CEK KELURAHAN/KECAMATAN
            const res = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&zoom=18&addressdetails=1`);
            const data = await res.json();
            
            const v = data.address;
            const kel = v.village || v.suburb || v.neighbourhood || "Tidak Terdeteksi";
            const kec = v.city_district || v.district || "Tidak Terdeteksi";
            
            alamatLengkap = `Kel. ${kel}, Kec. ${kec}`;
            
            box.innerHTML = `✅ LOKASI TERKUNCI<br><b style="font-size:14px; color:#1b5e20;">${alamatLengkap}</b><br><small>${lat}, ${lng}</small>`;
            box.style.background = "#e8f5e9";
            box.style.color = "#2e7d32";
            
        } catch (e) {
            box.innerHTML = "✅ KOORDINAT TERKUNCI (Gagal deteksi nama wilayah)";
        }
    }, () => {
        alert("Gagal melacak! Pastikan GPS HP Aktif.");
        box.innerText = "❌ GPS Gagal";
    }, { enableHighAccuracy: true });
}

async function kirim() {
    const file = document.getElementById('foto').files[0];
    const kat = document.getElementById('kat').value;
    const ket = document.getElementById('ket').value;
    const btn = document.getElementById('btnLapor');

    if(!lat || !lng) return alert("Kunci LOKASI GPS dulu!");
    if(!file) return alert("Foto bukti wajib ada!");

    btn.innerText = "⏳ SEDANG MENGIRIM...";
    btn.disabled = true;

    try {
        let fd = new FormData(); 
        fd.append("image", file);
        let resImg = await fetch("https://api.imgbb.com/1/upload?key=" + IMGBB, {method:"POST", body:fd});
        let dataImg = await resImg.json();
        
        const mapsUrl = "https://www.google.com/maps?q=" + lat + "," + lng;

        // Keterangan otomatis ditambah nama wilayah hasil deteksi GPS
        const keteranganFinal = `[${alamatLengkap}] ${ket}`;

        await fetch(SAKTI, {
            method: 'POST',
            mode: 'no-cors',
            body: JSON.stringify({
                nama: label,
                kategori: kat,
                keterangan: keteranganFinal,
                lokasi: mapsUrl,
                foto: dataImg.data.url
            })
        });

        alert("Laporan Berhasil Terkirim!");
        window.location.reload();
    } catch(e) {
        alert("Gagal Kirim!");
        btn.innerText = "🚀 KIRIM LAPORAN";
        btn.disabled = false;
    }
}
