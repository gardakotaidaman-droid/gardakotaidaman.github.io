const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
const IMGBB = "2e07237050e6690770451ded20f761b5";
const label = localStorage.getItem("user_label");
document.getElementById('op-name').innerText = label;

async function kirim() {
    const file = document.getElementById('foto').files[0];
    const lat = localStorage.getItem("last_lat");
    if(!file || !lat) return alert("Foto & Kunci GPS di modul Aksi wajib!");
    
    const btn = document.getElementById('btnLapor');
    btn.innerText = "⌛ Mengirim..."; btn.disabled = true;

    let fd = new FormData(); fd.append("image", file);
    let rI = await fetch("https://api.imgbb.com/1/upload?key="+IMGBB, {method:"POST", body:fd});
    let dI = await rI.json();

    await fetch(SAKTI, {
        method:'POST', mode:'no-cors',
        body: JSON.stringify({ nama:label, kategori:document.getElementById('kat').value, keterangan:document.getElementById('ket').value, lokasi:`https://www.google.com/maps?q=${lat},${localStorage.getItem("last_lng")}`, foto:dI.data.url })
    });
    alert("Laporan Terkirim!"); window.location.reload();
}
