const label = localStorage.getItem("user_label");
if(!label) window.location.href="../admin/login.html";
document.getElementById('op-name').innerText = label;

async function lapor() {
    const f = document.getElementById('foto').files[0];
    if(!f) return alert("Wajib lampirkan foto!");
    document.getElementById('btnLapor').innerText = "⌛ Mengirim...";
    // Logika upload ImgBB & simpan Sheets sama seperti sebelumnya
    alert("Berhasil dikirim sebagai " + label);
    window.location.reload();
}
