# Changelog - SiPresensi Update

Tanggal: Thursday, August 22, 2025

## Perubahan yang Dilakukan

### 1. Fitur Opsi Input Manual untuk Absensi Siswa
- **File yang Diubah:** 
  - `sipresensi-backend/app/Http/Controllers/API/StudentAttendanceController.php`
  - `api_student_attendance.md`
- **Deskripsi:**
  - Memodifikasi method `scanStudentQR` untuk menerima parameter `nisn_nip_nik` sebagai alternatif untuk `qr_code`.
  - Menambahkan validasi untuk memastikan salah satu dari `qr_code` atau `nisn_nip_nik` disediakan.
  - Memperbarui logika untuk mencari siswa berdasarkan `nisn_nip_nik` jika parameter ini disediakan.
  - Memperbarui dokumentasi API untuk mencerminkan perubahan ini.

### 2. Fitur Absensi Massal per Kelas
- **File yang Diubah:**
  - `sipresensi-backend/app/Http/Controllers/API/StudentAttendanceController.php`
  - `sipresensi-backend/routes/api.php`
  - `api_student_attendance.md`
- **Deskripsi:**
  - Menambahkan method baru `bulkAttendance` untuk menangani absensi massal.
  - Menambahkan endpoint baru `POST /api/student-attendance/bulk` di file routing.
  - Menambahkan validasi dan logika bisnis untuk absensi massal.
  - Memastikan bahwa siswa yang sudah absen tidak diabsen ulang.
  - Memperbarui dokumentasi API untuk mencerminkan endpoint baru ini.

### 3. Pembaruan Database
- **File yang Diubah:**
  - `Database_Sipresensi_Final.sql`
- **Deskripsi:**
  - Menambahkan perintah `CREATE TABLE student_qr_cards` beserta data contohnya ke dalam file database utama.
  - Memastikan bahwa tabel `student_qr_cards` akan dibuat secara otomatis saat database diimpor.

### 4. Pembaruan Dokumentasi
- **File yang Diubah:**
  - `sipresensi_project_summary.md`
- **Deskripsi:**
  - Memperbarui ringkasan proyek untuk mencerminkan fitur-fitur baru yang telah diimplementasikan.
  - Menambahkan informasi tentang endpoint baru dan cara menggunakannya.
  - Memperbarui daftar kredensial login default untuk testing.

## File yang Disimpan di Folder @Update checkpoint
1. `sipresensi_project_summary.md` - Ringkasan proyek yang diperbarui
2. `api_student_attendance.md` - Dokumentasi API yang diperbarui
3. `Database_Sipresensi_Final.sql` - File database yang diperbarui
4. `StudentAttendanceController.php` - Controller yang diperbarui
5. `api.php` - File routing yang diperbarui
6. `changelog.md` - File ini

---
*Dibuat untuk mendokumentasikan perubahan dan update pada proyek SiPresensi.*