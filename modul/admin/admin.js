const SAKTI = "https://script.google.com/macros/s/AKfycbwCKYJOQyULCxf5skOQ5AC9BpgR9beG3Uw3M1iMTEOoUgkRPvtGlybwK9iz19PGD0P5ww/exec";
if(localStorage.getItem("role") !== "admin") window.location.href="login.html";

async function loadData() {
    const r = await fetch(SAKTI);
    const d = await r.json();
    
    let logH = "";
    d.logs.reverse().slice(0,10).forEach(l => {
        logH += `<div style="font-size:11px; padding:5px; border-bottom:1px solid #eee;">[${new Date(l[0]).toLocaleTimeString()}] ${l[1]} ${l[2]}</div>`;
    });
    document.getElementById('log-list').innerHTML = logH;

    let html = "";
    d.laporan.reverse().forEach((i, idx) => {
        if(idx === d.laporan.length - 1 || !i[0]) return;
        html += `<div class="card" style="border-left:5px solid var(--primary);">
            <div style="display:flex; justify-content:space-between;">
                <small><b>${i[1]}</b></small>
                <span class="badge b-${i[6].toLowerCase()}">${i[6]}</span>
            </div>
            <p style="font-size:13px; margin:10px 0;">${i[3]}</p>
            <div style="display:flex; gap:5px;">
                <button class="btn-main" style="padding:5px; font-size:10px; background:#0288d1; flex:1;" onclick="upd('${i[0]}','Verifikasi')">VERIF</button>
                <button class="btn-main" style="padding:5px; font-size:10px; background:#ff9800; flex:1;" onclick="upd('${i[0]}','Penanganan')">TANGANI</button>
                <button class="btn-main" style="padding:5px; font-size:10px; background:#388e3c; flex:1;" onclick="upd('${i[0]}','Selesai')">DONE</button>
            </div>
        </div>`;
    });
    document.getElementById('wf-list').innerHTML = html;
}
async function upd(ts, st) {
    await fetch(SAKTI, { method:'POST', mode:'no-cors', body: JSON.stringify({ action:'updateStatus', id:ts, status:st }) });
    alert("Berhasil!"); location.reload();
}
loadData();
