const WA_CAMAT = "6285172206884";
function trackMe() {
    const box = document.getElementById('gps-txt');
    box.innerText = "⌛ Melacak Lokasi...";
    navigator.geolocation.getCurrentPosition(p => {
        const lat = p.coords.latitude; const lng = p.coords.longitude;
        box.innerHTML = `✅ <b>LOKASI TERKUNCI</b><br>Lat: ${lat}, Lng: ${lng}`;
        localStorage.setItem("last_lat", lat); localStorage.setItem("last_lng", lng);
    });
}
function callWA() { window.location.href = "https://wa.me/" + WA_CAMAT + "?text=LAPOR DARURAT!"; }
