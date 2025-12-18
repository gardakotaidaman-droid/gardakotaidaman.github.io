// DATABASE USER & PASSWORD (Kunci Mati)
const admins = ["camat", "sekcam", "trantib", "kapolsek", "danramil"];
const kels = ["rimbas", "sukajadi", "laksamana", "dumaikota", "bintan"];
const roles = ["lurah", "babinsa", "bhabin", "pamong", "trantib"];

function authSistem() {
    const u = document.getElementById('user').value.toLowerCase();
    const p = document.getElementById('pass').value;
    let role = "";
    let label = "";

    // 1. Validasi Admin (Pass: dksiaga)
    if(admins.includes(u) && p === "dksiaga") { 
        role = "admin"; 
        label = u.toUpperCase(); 
    }
    // 2. Validasi Operator Kelurahan (Pass: pantaudk)
    else {
        kels.forEach(k => roles.forEach(r => {
            if(u === `${r}-${k}` && p === "pantaudk") { 
                role = "operator"; 
                label = u.toUpperCase().replace("-"," "); 
            }
        }));
    }

    // 3. Eksekusi Login
    if(role) {
        localStorage.setItem("role", role); 
        localStorage.setItem("user_label", label);
        
        // --- PERBAIKAN JALUR REDIRECT ---
        // Kita gunakan path yang jelas agar tidak nyasar
        if (role === "admin") {
            // Jika admin, arahkan ke dashboard utama admin
            window.location.href = "index.html"; 
        } else {
            // Jika operator, lempar keluar ke folder operator
            window.location.href = "../operator/index.html";
        }
    } else {
        alert("⚠️ AKSES DITOLAK!\nUsername atau Password salah.");
    }
}

// FUNGSI SATPAM (Proteksi Halaman)
function proteksiHalaman(tipe) {
    const r = localStorage.getItem("role");
    const l = localStorage.getItem("user_label");
    
    // Jika tidak ada data login, atau operator coba-coba masuk folder admin
    if(!l || (tipe === 'admin' && r !== 'admin')) {
        // Tendang balik ke halaman login
        window.location.href = "../admin/login.html";
    }
}