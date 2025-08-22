# SiPresensi - Ringkasan Proyek dan Status Terkini

Tanggal Terakhir Update: Friday, August 22, 2025
Waktu: 15:30 WIB

## 1. Deskripsi Singkat Proyek

**Nama Aplikasi:** Sipresensi (Sistem Presensi Digital Sekolah)
**Tujuan:** Aplikasi mobile untuk manajemen absensi digital di lingkungan sekolah dengan fitur keamanan tinggi seperti verifikasi lokasi GPS, foto selfie, dan pemindaian QR Code dinamis.

## 2. Arsitektur Sistem

- **Frontend (Mobile App):** React Native (Expo) + Tamagui + Nativewind
- **Frontend (Web Admin):** Vue.js (belum dikembangkan)
- **Backend:** Laravel (PHP) sebagai REST API
- **Database:** MySQL (via XAMPP)
- **Hosting:** Lokal (PC/server sekolah)

## 3. Spesifikasi Teknis dan Lingkungan Pengembangan

- **Database Name:** `sipresensi`
- **Backend Server:** Laravel (dijalankan dengan `php artisan serve`)
- **Scheduler QR Code:** Diaktifkan dengan `run_scheduler.bat`
- **Kredensial Login Default (untuk testing):**
  - Siswa: `1001`, `1002`, `1003`, `1004` (Password: `password`)
  - Guru: `2001`, `2002` (Password: `password`)
  - Pegawai: `3001` (Password: `password`)
  - Kepala Sekolah: `4001` (Password: `password`)
  - Admin: `5001` (Password: `password`)

## 4. Struktur Database (Tabel Penting)

### 4.1. users
- `id` (BIGINT, PK)
- `nisn_nip_nik` (VARCHAR(50), UNI) - Digunakan untuk login
- `name` (VARCHAR(100))
- `email` (VARCHAR(100), UNI)
- `phone` (VARCHAR(20))
- `password` (VARCHAR(255)) - Hashed
- `role_id` (INT, FK ke `roles`)
- `photo_path` (VARCHAR(255))
- `is_active` (BOOLEAN)
- `created_at`, `updated_at` (TIMESTAMP)

### 4.2. roles
- `id` (INT, PK)
- `name` (VARCHAR(50), UNI) - e.g., 'siswa', 'guru', 'pegawai', 'kepala_sekolah', 'admin'
- `description` (TEXT)

### 4.3. dynamic_qr_tokens
- `id` (BIGINT, PK)
- `token` (VARCHAR(255), UNI) - Token QR dinamis
- `created_at` (DATETIME)
- `expires_at` (DATETIME) - Kadaluarsa 15 detik setelah dibuat
- `used` (BOOLEAN) - Apakah token sudah digunakan
- `used_by` (BIGINT, FK ke `users`) - ID user yang menggunakan token
- `used_at` (DATETIME)
- Indexes: `idx_token`, `idx_expires`

### 4.4. student_qr_cards
- `id` (BIGINT, PK)
- `student_id` (BIGINT, FK ke `users`)
- `qr_code` (VARCHAR(255), UNI) - QR code statis siswa
- `is_active` (BOOLEAN)
- `generated_at` (TIMESTAMP)
- `created_at`, `updated_at` (TIMESTAMP)
- Indexes: `idx_student_id`, `idx_qr_code`, `idx_is_active`

### 4.5. classes
- `id` (INT, PK)
- `name` (VARCHAR(50)) - e.g., 'X IPA 1'
- `homeroom_teacher_id` (BIGINT, FK ke `users`)

### 4.6. student_class
- `id` (BIGINT, PK)
- `student_id` (BIGINT, FK ke `users`)
- `class_id` (INT, FK ke `classes`)
- `academic_year` (YEAR)
- Unique Key: `unique_student_class` (student_id, class_id, academic_year)

### 4.7. attendance
- `id` (BIGINT, PK)
- `user_id` (BIGINT, FK ke `users`)
- `type` (ENUM: 'checkin', 'checkout')
- `latitude` (DECIMAL(10,8))
- `longitude` (DECIMAL(11,8))
- `accuracy` (FLOAT)
- `photo_path` (VARCHAR(255)) atau base64 foto
- `qr_token_used` (VARCHAR(255)) - Token QR yang digunakan atau metode absensi
- `status` (ENUM: 'hadir', 'terlambat', 'izin', 'sakit', 'alpha')
- `timestamp` (DATETIME)
- `date_only` (DATE) - Untuk indexing
- `synced` (BOOLEAN)
- `created_at` (TIMESTAMP)
- Indexes: `idx_attendance_user_date`, `idx_attendance_timestamp`, `idx_attendance_qr_token`

### 4.8. leaves
- `id` (BIGINT, PK)
- `user_id` (BIGINT, FK ke `users`)
- `leave_type` (ENUM: 'izin', 'cuti', 'dinas_luar', 'sakit')
- `start_date`, `end_date` (DATE)
- `reason` (TEXT)
- `attachment_path` (VARCHAR(255))
- `status` (ENUM: 'menunggu', 'disetujui', 'ditolak')
- `approved_by` (BIGINT, FK ke `users`)
- `approval_comment` (TEXT)
- `approved_at` (DATETIME)
- `created_at`, `updated_at` (TIMESTAMP)
- Indexes: `idx_leaves_user_status`, `idx_leaves_date`

### 4.9. announcements
- `id` (BIGINT, PK)
- `title` (VARCHAR(255))
- `content` (TEXT)
- `author_id` (BIGINT, FK ke `users`)
- `is_published` (BOOLEAN)
- `published_at` (DATETIME)
- `created_at`, `updated_at` (TIMESTAMP)
- Indexes: `idx_announcements_published`

## 5. API Endpoint Utama

### 5.1. Autentikasi
- `POST /api/auth/login` - Login dengan `nisn_nip_nik` dan `password`
- `POST /api/auth/logout` - Logout (jika menggunakan token berbasis sesi)

### 5.2. User & Profil
- `GET /api/user` - Mendapatkan data user yang sedang login
- `GET /api/profile` - Mendapatkan profil user
- `PUT /api/profile` - Memperbarui profil
- `PUT /api/profile/password` - Mengganti password

### 5.3. QR Code & Absensi Pegawai/Guru/Kepsek
- `GET /api/qrcode/dynamic` - Mendapatkan token QR dinamis
- `POST /api/qrcode/verify` - Verifikasi token QR dan submit absensi (checkin/checkout)

### 5.4. Absensi Siswa (oleh Guru)
- `POST /api/student-attendance/scan-qr` - Scan QR code siswa atau input manual NISN/NIP/NIK untuk absen
- `POST /api/student-attendance/bulk` - Absensi massal untuk semua siswa dalam satu kelas
- `GET /api/student-attendance/class-status/{classId}` - Mendapatkan status absensi per kelas

### 5.5. Manajemen Izin
- `GET /api/leaves` - Mendapatkan daftar izin (dengan filter)
- `POST /api/leaves` - Mengajukan izin baru
- `GET /api/leaves/{id}` - Mendapatkan detail izin
- `PUT /api/leaves/{id}` - Memperbarui izin (misalnya untuk persetujuan)
- `DELETE /api/leaves/{id}` - Menghapus izin

### 5.6. Pengumuman
- `GET /api/announcements` - Mendapatkan daftar pengumuman
- `POST /api/announcements` - Membuat pengumuman baru
- `GET /api/announcements/{id}` - Mendapatkan detail pengumuman
- `PUT /api/announcements/{id}` - Memperbarui pengumuman
- `DELETE /api/announcements/{id}` - Menghapus pengumuman

### 5.7. Manajemen Kelas
- `GET /api/classes` - Mendapatkan semua kelas
- `GET /api/classes/{id}` - Mendapatkan kelas berdasarkan ID
- `POST /api/classes` - Membuat kelas baru (admin only)
- `PUT /api/classes/{id}` - Memperbarui kelas (admin only)
- `DELETE /api/classes/{id}` - Menghapus kelas (admin only)
- `GET /api/classes/{id}/students` - Mendapatkan semua siswa dalam kelas
- `POST /api/classes/{id}/assign-students` - Menetapkan siswa ke kelas (admin only)
- `POST /api/classes/{id}/remove-students` - Menghapus siswa dari kelas (admin only)

### 5.8. Student QR Cards
- `GET /api/student-qr-cards` - Mendapatkan semua QR card siswa
- `GET /api/student-qr-cards/{id}` - Mendapatkan QR card siswa berdasarkan ID
- `POST /api/student-qr-cards/generate` - Mengenerate QR code baru untuk siswa
- `PUT /api/student-qr-cards/{id}/status` - Memperbarui status QR card (aktif/tidak aktif)

### 5.9. Offline Sync
- `GET /api/offline-sync` - Mendapatkan semua log sinkronisasi offline
- `GET /api/offline-sync/{id}` - Mendapatkan log sinkronisasi offline berdasarkan ID
- `POST /api/offline-sync/process-attendance` - Memproses data absensi offline
- `POST /api/offline-sync/{id}/retry` - Mencoba ulang sinkronisasi log yang gagal

### 5.10. Settings
- `GET /api/settings` - Mendapatkan semua pengaturan sistem
- `GET /api/settings/{key}` - Mendapatkan pengaturan sistem berdasarkan key
- `PUT /api/settings/{key}` - Memperbarui pengaturan sistem berdasarkan key
- `PUT /api/settings/bulk-update` - Memperbarui banyak pengaturan sekaligus

### 5.11. Dashboard
- `GET /api/dashboard` - Mendapatkan data dashboard berdasarkan peran pengguna

### 5.12. Manajemen Pengguna (Admin)
- `GET /api/users` - Mendapatkan daftar pengguna
- `POST /api/users` - Menambah pengguna baru
- `GET /api/users/{id}` - Mendapatkan detail pengguna
- `PUT /api/users/{id}` - Memperbarui pengguna
- `DELETE /api/users/{id}` - Menghapus pengguna

## 6. Fitur yang Telah Diimplementasikan

### 6.1. Fitur Inti (Sudah Ada)
1. ✅ Sistem Autentikasi & Otorisasi
2. ✅ Sistem QR Code Dinamis (15 detik)
3. ✅ Absensi Guru/Pegawai/Kepala Sekolah
4. ✅ Absensi Siswa oleh Guru (Scan QR Statis)
5. ✅ Manajemen Izin
6. ✅ Pengumuman
7. ✅ Manajemen Profil
8. ✅ Manajemen Pengguna
9. ✅ Manajemen Kelas
10. ✅ Student QR Cards
11. ✅ Offline Sync
12. ✅ Settings
13. ✅ Dashboard

### 6.2. Fitur Tambahan yang Baru Diimplementasikan
1. ✅ **Opsi Input Manual untuk Absensi Siswa**
   - Endpoint `POST /api/student-attendance/scan-qr` sekarang mendukung input `nisn_nip_nik` sebagai alternatif untuk `qr_code`.
   - Memungkinkan absensi siswa jika kartu QR rusak.
   - Dokumentasi API diperbarui di `api_student_attendance.md`.

2. ✅ **Absensi Massal per Kelas**
   - Endpoint baru `POST /api/student-attendance/bulk` untuk mengabsen semua siswa dalam satu kelas sekaligus.
   - Mencegah absensi ganda untuk siswa yang sudah absen.
   - Hanya dapat diakses oleh guru.
   - Dokumentasi API diperbarui di `api_student_attendance.md`.

## 7. File-file Penting dan Catatan Khusus

### 7.1. File Dokumentasi & Konfigurasi Utama
- `PRD_SystemArchitecture_Sipresensi.txt` - Product Requirements Document dan arsitektur sistem.
- `Database_Sipresensi_Final.sql` - File SQL untuk membuat struktur database yang benar (sudah diperbarui dengan tabel `student_qr_cards`).
- `api_documentation_complete.md` - Dokumentasi lengkap API.
- `api_student_attendance.md` - Dokumentasi API khusus absensi siswa (sudah diperbarui dengan endpoint baru).
- `qr_code_mechanism.md` - Dokumentasi mekanisme QR code.
- `run_scheduler.bat` - Script batch untuk menjalankan scheduler QR code.

### 7.2. Catatan Penting
- Database **harus** dibuat menggunakan struktur dari `Database_Sipresensi_Final.sql`.
- Tabel `student_qr_cards` sudah ada dalam `Database_Sipresensi_Final.sql` sehingga tidak perlu dibuat secara terpisah.
- Untuk menambahkan siswa baru, pastikan juga menambahkan entri di tabel `student_qr_cards`.

### 7.3. File Update dalam Folder `@Update checkpoint`
Berikut adalah daftar file update yang telah disimpan dalam folder `@Update checkpoint`:
- `sipresensi_project_summary.md` - Ringkasan proyek yang diperbarui (file ini)
- `StudentAttendanceController.php` - Controller yang telah dimodifikasi
- `api_student_attendance.md` - Dokumentasi API yang diperbarui
- `api_documentation_complete.md` - Dokumentasi API lengkap
- `api_auth.md` - Dokumentasi API autentikasi
- `api_user_profile.md` - Dokumentasi API user & profil
- `api_qr_code.md` - Dokumentasi API QR Code
- `api_attendance.md` - Dokumentasi API absensi pegawai/guru/kepsek
- `api_leaves.md` - Dokumentasi API manajemen izin
- `api_announcements.md` - Dokumentasi API pengumuman
- `api_classes.md` - Dokumentasi API manajemen kelas
- `api_student_qr_cards.md` - Dokumentasi API student QR cards
- `api_offline_sync.md` - Dokumentasi API offline sync
- `api_settings.md` - Dokumentasi API settings
- `api_dashboard.md` - Dokumentasi API dashboard
- `api_user_management.md` - Dokumentasi API manajemen pengguna
- `changelog_20250822_1045.md` - Catatan perubahan
- `developer_summary_20250822_1050.md` - Ringkasan perubahan untuk developer
- `changelog_20250822_1430.md` - Catatan perubahan terbaru
- `developer_summary_20250822_1445.md` - Ringkasan perubahan untuk developer (diperbarui)

## 8. Instruksi Menjalankan Sistem

1. **Setup Database:**
   - Pastikan MySQL (XAMPP) berjalan.
   - Buat database `sipresensi`.
   - Impor struktur dan data dari `Database_Sipresensi_Final.sql`.
   - Pastikan tabel `student_qr_cards` ada dan terisi.

2. **Jalankan Backend Server (Laravel):**
   - Buka command prompt di direktori `sipresensi-backend`.
   - Jalankan perintah: `php artisan serve`

3. **Aktifkan Scheduler QR Code:**
   - Jalankan `run_scheduler.bat` untuk mengaktifkan generator token QR dinamis setiap 15 detik.

4. **Gunakan API sesuai dokumentasi.**

5. **Testing Endpoint Baru:**
   - Untuk menguji opsi input manual: `POST /api/student-attendance/scan-qr` dengan parameter `nisn_nip_nik`.
   - Untuk menguji absensi massal: `POST /api/student-attendance/bulk` dengan parameter `class_id`.

---
*File ini dibuat untuk menyediakan snapshot cepat dari status dan konfigurasi project SiPresensi.*
*Terakhir diperbarui: August 22, 2025*