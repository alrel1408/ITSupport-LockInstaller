# 🔒 Install Password Lock Tool - GUI Version

Tool dengan **interface grafis (GUI)** untuk mengunci instalasi software dan manajemen akun Administrator di Windows.

## 📋 Deskripsi

Tool ini memungkinkan Anda untuk:
- **Mengunci instalasi software** - User biasa memerlukan password Administrator untuk install aplikasi
- **Manajemen akun user** - Buat, hapus, dan ubah status user dengan mudah
- **Kontrol keamanan sistem** - Monitor status keamanan Windows secara real-time

## ⚠️ Persyaratan

- **Windows 10/11** (atau Windows Server)
- **PowerShell 5.1** atau lebih baru
- **Hak Administrator** untuk menjalankan tool
- **.NET Framework** (biasanya sudah terinstall di Windows)

## 🚀 Cara Menjalankan

### Metode 1: Klik Kanan (Recommended)
1. **Klik kanan** pada file `InstallPasswordLock-GUI.ps1`
2. Pilih **"Run with PowerShell"**
3. Jika muncul dialog UAC, klik **"Yes"**

### Metode 2: PowerShell Manual
1. Buka **PowerShell sebagai Administrator**
2. Navigate ke folder tool: `cd "C:\path\to\tool"`
3. Jalankan: `.\InstallPasswordLock-GUI.ps1`

### Metode 3: Command Prompt
1. Buka **Command Prompt sebagai Administrator**
2. Jalankan: `powershell -ExecutionPolicy Bypass -File "InstallPasswordLock-GUI.ps1"`

## 📊 Interface Utama

Tool memiliki **8 menu utama** yang terbagi dalam 2 panel:

### Panel Kiri - Menu Kontrol
1. **[LOCK] AKTIFKAN KUNCI INSTALASI** (Hijau)
2. **[UNLOCK] NONAKTIFKAN KUNCI INSTALASI** (Merah)
3. **[PROFILE] TAMBAHKAN PROFIL AKUN BARU** (Biru)
4. **[ADMIN] AKTIFKAN ADMINISTRATOR BUILT-IN** (Kuning)
5. **[PASS] UBAH PASSWORD USER** (Ungu)
6. **[ROLE] UBAH STATUS USER (ADMIN/USER)** (Biru)
7. **[DELETE] HAPUS USER ACCOUNT** (Merah)
8. **[REFRESH] REFRESH STATUS** (Abu-abu)

### Panel Kanan - Status Monitor
- **Status UAC** - Level keamanan sistem
- **Status Instalasi MSI** - Apakah instalasi dikunci
- **Daftar Administrator** - Semua akun admin aktif

## 🔧 Panduan Penggunaan

### 1. Mengaktifkan Kunci Instalasi

**Tujuan**: Mencegah user biasa install software tanpa password admin

**Langkah**:
1. Klik tombol **[LOCK] AKTIFKAN KUNCI INSTALASI**
2. Tunggu proses selesai
3. Lihat konfirmasi "Kunci Instalasi berhasil DIAKTIFKAN!"

**Hasil**: 
- User biasa akan diminta password Administrator saat install software
- UAC diset ke level maksimum
- Instalasi MSI dikunci untuk non-admin

### 2. Membuat Profil Akun Baru

**Tujuan**: Menambahkan user baru dengan role Administrator atau Standard User

**Langkah**:
1. Klik tombol **[PROFILE] TAMBAHKAN PROFIL AKUN BARU**
2. Isi **Nama User Baru** (contoh: "JohnDoe")
3. Isi **Password** (minimal 4 karakter)
4. Isi **Konfirmasi Password** (harus sama)
5. Pilih **Tipe Akun**:
   - **Administrator**: Dapat install software dan mengubah sistem
   - **Standard User**: Dapat login normal, tidak dapat install software
6. Klik **[OK] BUAT PROFIL**

**Tips**:
- Gunakan password yang kuat (kombinasi huruf, angka, simbol)
- Standard User cocok untuk anak-anak atau karyawan
- Administrator untuk IT support atau pemilik PC

### 3. Mengubah Status User

**Tujuan**: Mengubah user dari Administrator ke Standard User atau sebaliknya

**Langkah**:
1. Klik tombol **[ROLE] UBAH STATUS USER (ADMIN/USER)**
2. Pilih user dari dropdown (menampilkan status saat ini)
3. Pilih status baru dengan radio button
4. Klik **[OK] UBAH STATUS**

**Contoh Penggunaan**:
- Menurunkan hak akses karyawan yang resign
- Memberikan hak admin sementara untuk instalasi
- Mengubah akun anak dari admin ke standard user

### 4. Mengubah Password User

**Tujuan**: Mengganti password user yang lupa atau untuk keamanan

**Langkah**:
1. Klik tombol **[PASS] UBAH PASSWORD USER**
2. Pilih user dari dropdown
3. Isi **Password Baru** (minimal 4 karakter)
4. Isi **Konfirmasi Password**
5. Klik **[OK] UBAH**

### 5. Menghapus User Account

**Tujuan**: Menghapus user yang tidak diperlukan lagi

**Langkah**:
1. Klik tombol **[DELETE] HAPUS USER ACCOUNT**
2. Pilih user yang akan dihapus (tidak termasuk user aktif dan built-in)
3. Klik **[DELETE] HAPUS**
4. Konfirmasi dengan **"Yes"** pada dialog peringatan

**⚠️ Peringatan**: Tindakan ini tidak dapat dibatalkan!

### 6. Mengaktifkan Administrator Built-in

**Tujuan**: Mengaktifkan akun "Administrator" bawaan Windows

**Langkah**:
1. Klik tombol **[ADMIN] AKTIFKAN ADMINISTRATOR BUILT-IN**
2. Isi **Password Baru** untuk akun Administrator
3. Isi **Konfirmasi Password**
4. Klik **[OK] AKTIFKAN**

**Kegunaan**: Backup admin account jika akun utama bermasalah

## 🛡️ Keamanan dan Best Practices

### Password yang Kuat
- **Minimal 8 karakter**
- **Kombinasi**: Huruf besar + kecil + angka + simbol
- **Hindari**: 12345, password, admin, nama sendiri
- **Contoh bagus**: `Admin@2024!`, `SecureP@ss99`

### Manajemen User
- **Buat minimal 2 akun admin** untuk backup
- **Gunakan Standard User** untuk penggunaan sehari-hari
- **Simpan password** di tempat yang aman
- **Ganti password** secara berkala

### Monitoring
- **Refresh status** secara berkala untuk melihat perubahan
- **Monitor daftar administrator** untuk mendeteksi akun tidak dikenal
- **Periksa status kunci** setelah restart sistem

## 🔍 Troubleshooting

### Tool Tidak Bisa Dibuka
**Masalah**: Error "execution policy" atau "access denied"

**Solusi**:
1. Pastikan menjalankan **sebagai Administrator**
2. Buka PowerShell sebagai Admin, jalankan:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Coba jalankan tool lagi

### User Tidak Bisa Login Setelah Diubah
**Masalah**: User hilang dari login screen

**Solusi**: Tool sudah diperbaiki untuk menambahkan user ke grup "Users" otomatis. Jika masih bermasalah:
1. Login sebagai Administrator lain
2. Gunakan menu **[ROLE] UBAH STATUS USER** untuk reset status user
3. Atau gunakan **[DELETE]** dan buat ulang user

### Kunci Instalasi Tidak Bekerja
**Masalah**: User biasa masih bisa install software

**Solusi**:
1. Pastikan kunci sudah diaktifkan (cek status panel kanan)
2. Restart komputer atau logout/login ulang
3. Beberapa installer mungkin bypass UAC (normal)

### GUI Tidak Muncul atau Error
**Masalah**: Form tidak terbuka atau crash

**Solusi**:
1. Pastikan Windows sudah update
2. Install .NET Framework terbaru
3. Restart komputer dan coba lagi

## 📝 Skenario Penggunaan

### Untuk Rumah Tangga
1. **Aktifkan kunci instalasi**
2. **Buat akun Standard User** untuk anak-anak
3. **Gunakan akun Administrator** hanya untuk instalasi software
4. **Monitor aktivitas** melalui status panel

### Untuk Kantor/Sekolah
1. **Aktifkan kunci instalasi** di semua PC
2. **Buat akun Standard User** untuk karyawan/siswa
3. **Buat akun Administrator** untuk IT support
4. **Ganti password** secara berkala untuk keamanan

### Untuk Warnet/Lab Komputer
1. **Aktifkan kunci instalasi**
2. **Gunakan akun Standard User** untuk customer
3. **Hapus akun temporary** setelah selesai digunakan
4. **Reset password** secara berkala

## 📞 Support

Jika mengalami masalah:
1. Periksa **troubleshooting** di atas
2. Pastikan menjalankan **sebagai Administrator**
3. Restart komputer jika diperlukan
4. Backup data penting sebelum melakukan perubahan sistem

## 📄 Lisensi

Tool ini gratis untuk digunakan. Gunakan dengan bijak dan tanggung jawab.

---

**Dibuat dengan ❤️ untuk keamanan Windows yang lebih baik**