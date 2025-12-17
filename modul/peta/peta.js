var map = L.map('map').setView([1.680, 101.448], 14);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
async function load() {
    const r = await fetch("https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec"); const d = await r.json();
    d.laporan.reverse().forEach((i, idx) => {
        if(!i[4]) return; const c = i[4].match(/q=(-?\d+\.\d+),(-?\d+\.\d+)/);
        if(c) L.circleMarker([c[1], c[2]], {color: i[6]=='Selesai'?'green':'red'}).addTo(map).bindPopup(`<b>${i[1]}</b><br>${i[3]}`);
    });
}
load();
