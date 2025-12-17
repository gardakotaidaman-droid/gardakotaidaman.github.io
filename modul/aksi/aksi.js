function trackLokasi() {
    const box = document.getElementById('gps-txt');
    box.innerText = "⌛ Melacak Lokasi...";
    navigator.geolocation.getCurrentPosition(p => {
        box.innerHTML = "✅ LOKASI TERKUNCI<br>Lat: " + p.coords.latitude + "<br>Long: " + p.coords.longitude;
        localStorage.setItem("current_lat", p.coords.latitude);
        localStorage.setItem("current_lng", p.coords.longitude);
    }, () => alert("Aktifkan GPS!"));
}
