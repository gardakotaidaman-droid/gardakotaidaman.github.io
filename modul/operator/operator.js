const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"; const IMGBB = "2e07237050e6690770451ded20f761b5"; const user = localStorage.getItem("user_label");
document.getElementById('op-name').innerText = user;
let lat="", lng="";
function track() {
    navigator.geolocation.getCurrentPosition(p => {
        lat = p.coords.latitude; lng = p.coords.longitude;
        document.getElementById('gps-msg').innerHTML = "✅ KOORDINAT TERKUNCI";
        fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action: "log", user: user, type: "Kunci GPS" }) });
    });
}
async function lapor() {
    const file = document.getElementById('foto').files[0];
    if(!file || !lat) return alert("Foto & GPS Wajib!");
    document.getElementById('btnL').innerText = "Mengirim...";
    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ nama:user, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:"http://googleusercontent.com/maps.google.com/q="+lat+","+lng, foto:dI.data.url }) });
    alert("Berhasil!"); location.reload();
}
