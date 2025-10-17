# 🔒 Install Password Lock Tool - GUI Version

Tool dengan **interface grafis (GUI)** untuk mengunci instalasi software dan manajemen akun Administrator di Windows.

## ✨ Fitur

- ✅ **Interface GUI yang Mudah**: Tampilan Windows Forms yang user-friendly
- ✅ **Kunci Instalasi**: Memaksa semua instalasi software memerlukan password Administrator
- ✅ **Buat Admin Baru**: Membuat akun Administrator baru dengan password
- ✅ **Aktifkan Admin Built-in**: Mengaktifkan akun Administrator bawaan Windows
- ✅ **Ubah Password**: Mengubah password user yang ada
- ✅ **Status Real-time**: Melihat status konfigurasi keamanan sistem secara langsung

## 🚀 Cara Menggunakan

### Metode 1: Double-click (PALING MUDAH) ⭐
1. **Double-click** file `JALANKAN_SEBAGAI_ADMIN.bat`
2. Klik **Yes** pada UAC prompt
3. **GUI akan muncul** - Klik tombol menu yang diinginkan!

### Metode 2: PowerShell Manual
1. Klik kanan pada `InstallPasswordLock-GUI.ps1`
2. Pilih **"Run with PowerShell"** atau **"Run as Administrator"**
3. GUI akan terbuka

## 📋 Tombol Menu GUI

### 🔒 Aktifkan Kunci Instalasi (Tombol Hijau)
Mengaktifkan proteksi instalasi dengan:
- UAC level maksimum
- Block instalasi MSI untuk non-admin
- Software Restriction Policy

**Efek**: User biasa TIDAK bisa install software tanpa memasukkan password Administrator.

### 🔓 Nonaktifkan Kunci Instalasi (Tombol Merah)
Mengembalikan pengaturan ke default (menonaktifkan kunci).

### 👤 Buat Akun Administrator Baru (Tombol Biru)
Membuka form untuk membuat user baru dengan hak Administrator penuh.

**Form isi**:
- Nama user baru
- Password
- Konfirmasi password

### ⚙️ Aktifkan Administrator Built-in Windows (Tombol Kuning)
Membuka form untuk mengaktifkan akun "Administrator" bawaan Windows.

**Form isi**:
- Password baru untuk Administrator
- Konfirmasi password

### 🔑 Ubah Password User (Tombol Ungu)
Membuka form untuk mengubah password user yang ada.

**Form isi**:
- Pilih user dari dropdown
- Password baru
- Konfirmasi password

### 🔄 Refresh Status (Tombol Putih)
Menampilkan informasi terbaru di panel kanan:
- Status UAC
- Status kunci instalasi MSI
- Daftar semua akun Administrator dengan status aktif/nonaktif

## ⚠️ Persyaratan

- **Windows 10/11** (atau Windows Server)
- **Hak Administrator** untuk menjalankan tool ini
- **PowerShell 5.0** atau lebih baru (sudah terinstall di Windows 10/11)

## 🛡️ Keamanan

### Apa yang Dilakukan Tool Ini?

1. **UAC (User Account Control)**
   - Mengatur ke level tertinggi
   - Setiap instalasi akan meminta password admin

2. **MSI Installer Restriction**
   - Mencegah user biasa install file .msi
   - Hanya Administrator yang bisa install

3. **Software Restriction Policy**
   - Lapisan keamanan tambahan
   - Kontrol eksekusi program

### Apakah Aman?

✅ **YA**, tool ini menggunakan:
- Fitur keamanan bawaan Windows
- Tidak menginstall software pihak ketiga
- Hanya mengubah registry dan policy Windows
- Semua perubahan bisa di-revert dengan menu [2]

## 📝 Contoh Skenario Penggunaan

### Skenario 1: Komputer Kantor
```
1. Jalankan tool
2. Pilih [1] - Aktifkan Kunci Instalasi
3. Pilih [3] - Buat akun "AdminKantor" 
4. Berikan password "AdminKantor" hanya ke IT Support
5. User biasa tidak bisa install software sembarangan
```

### Skenario 2: Komputer Anak
```
1. Jalankan tool
2. Pilih [1] - Aktifkan Kunci Instalasi
3. Pilih [4] - Aktifkan Administrator & set password
4. Anak tidak bisa install game/aplikasi tanpa izin
```

### Skenario 3: Komputer Warnet
```
1. Jalankan tool
2. Pilih [1] - Aktifkan Kunci Instalasi
3. Pilih [5] - Ubah password admin yang ada
4. Pelanggan tidak bisa install malware/software berbahaya
```

## 🔧 Troubleshooting

### "Script ini harus dijalankan sebagai Administrator"
**Solusi**: Klik kanan file → Run as Administrator

### "Execution Policy" Error
**Solusi**: Gunakan file `JALANKAN_SEBAGAI_ADMIN.bat` atau jalankan:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### Administrator Built-in Tidak Bisa Diaktifkan
**Solusi**: Kemungkinan nama user berbeda (misal: "Administrateur" di Windows Perancis).
Gunakan menu [3] untuk buat admin baru saja.

### Lupa Password Administrator
**Solusi**: 
1. Boot ke Safe Mode
2. Login dengan admin lain
3. Gunakan menu [5] untuk reset password

## 📞 Catatan Penting

- ⚠️ **SIMPAN PASSWORD DENGAN AMAN!** Jangan sampai lupa password Administrator.
- 💾 Buat akun Administrator cadangan untuk berjaga-jaga
- 🔄 Untuk mencabut semua perubahan, gunakan menu [2]

## 🎯 Tips Pro

1. **Selalu buat minimal 2 akun Administrator** untuk backup
2. **Gunakan password yang kuat** (minimal 8 karakter, kombinasi huruf-angka-simbol)
3. **Catat password di tempat aman** (password manager atau safe deposit)
4. **Test dengan user biasa** setelah mengaktifkan kunci untuk memastikan berfungsi

## 📜 License

Tool ini gratis untuk digunakan. Gunakan dengan bijak! 🚀

---

**Dibuat dengan ❤️ untuk meningkatkan keamanan Windows Anda**


