function sos() {
    navigator.geolocation.getCurrentPosition(p => {
        const maps = "http://googleusercontent.com/maps.google.com/q=" + p.coords.latitude + "," + p.coords.longitude;
        window.location.href = "https://wa.me/6285172206884?text=*🚨 SOS DARURAT!* Lokasi: " + maps;
    });
}
