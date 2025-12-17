let lat = "", lng = "";
const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const WA_CAMAT = "6285172206884";
const user = localStorage.getItem("user_label") || "Warga/Relawan";

function initGPS() {
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        document.getElementById('gps-status').innerHTML = "✅ LOKASI SIAP: " + lat + "," + lng;
    }, () => alert("Aktifkan GPS!"));
}

async function sendSOS() {
    if(!lat) return alert("Menunggu koordinat GPS...");
    if(confirm("Kirim sinyal DARURAT ke Camat & BPBD?")) {
        const maps = "http://googleusercontent.com/maps.google.com/q=" + lat + "," + lng;
        fetch(SAKTI, { method: 'POST', mode: 'no-cors', body: JSON.stringify({ nama: user, kategori: "🚨 SOS / DARURAT", keterangan: "Sinyal Bahaya Ditekan!", lokasi: maps }) });
        window.location.href = "https://wa.me/" + WA_CAMAT + "?text=*🚨 DARURAT SOS*%0A*Petugas:* " + user + "%0A*Lokasi:* " + maps;
    }
}
initGPS();
