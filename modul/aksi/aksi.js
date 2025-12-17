function trackMe() {
    const status = document.getElementById('gps-txt');
    status.innerText = "⌛ Melacak Koordinat...";
    navigator.geolocation.getCurrentPosition(p => {
        status.innerHTML = `✅ <b>LOKASI TERKUNCI</b><br>Lat: ${p.coords.latitude}<br>Lng: ${p.coords.longitude}`;
    }, () => alert("GPS Tidak Aktif!"));
}
