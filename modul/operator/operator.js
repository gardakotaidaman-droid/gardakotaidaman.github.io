const label = localStorage.getItem("user_label");
if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

async function kirimLaporan() {
    const btn = document.getElementById('btnKirim');
    btn.innerText = "⏳ Mengirim...";
    // Logika upload foto & simpan sheets
    alert("Laporan Berhasil dikirim oleh " + label);
}
