var map = L.map('map').setView([1.680, 101.448], 14);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

async function loadPeta() {
    const r = await fetch("https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec");
    const d = await r.json();
    d.laporan.reverse().forEach((item, idx) => {
        if(idx === d.laporan.length - 1 || !item[4]) return;
        const coords = item[4].match(/q=(-?\d+\.\d+),(-?\d+\.\d+)/);
        if(coords) {
            let color = item[6] === 'Selesai' ? 'green' : (item[6] === 'Penanganan' ? 'orange' : 'red');
            L.circleMarker([coords[1], coords[2]], { color: color, radius: 8 }).addTo(map)
                .bindPopup(`<b>${item[1]}</b><br>${item[3]}<br><img src="${item[5]}" style="width:100px">`);
        }
    });
}
loadPeta();
