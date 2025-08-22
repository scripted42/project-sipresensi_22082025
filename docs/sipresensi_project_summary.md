# SiPresensi - Ringkasan Proyek dan Status Terkini

Tanggal Terakhir Update: Thursday, August 21, 2025
Waktu: 19:30 WIB

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
  - Siswa: `1001`, `1002`, `1003` (Password: `password`)
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
- `expires_at` (DATETIME) - Kadaluarsa 10 detik setelah dibuat
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
- `qr_token_used` (VARCHAR(255), FK ke `dynamic_qr_tokens.token`)
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
- `POST /api/student-attendance/scan-qr` - Scan QR code siswa untuk absen
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

### 5.7. Manajemen Pengguna (Admin)
- `GET /api/users` - Mendapatkan daftar pengguna
- `POST /api/users` - Menambah pengguna baru
- `GET /api/users/{id}` - Mendapatkan detail pengguna
- `PUT /api/users/{id}` - Memperbarui pengguna
- `DELETE /api/users/{id}` - Menghapus pengguna

## 6. Status Checkpoint Terakhir

**CHECKPOINT - SiPresensi Project (Tanggal: Thursday, August 21, 2025, Waktu: 19:30 WIB)**

### STATUS: ✅ COMPLETE

#### FITUR INTI YANG TELAH SELESAI:
1. ✅ Sistem Autentikasi & Otorisasi
2. ✅ Sistem QR Code Dinamis (10 detik)
3. ✅ Absensi Guru/Pegawai/Kepala Sekolah
4. ✅ Absensi Siswa oleh Guru (Scan QR Statis)
5. ✅ Manajemen Izin
6. ✅ Pengumuman
7. ✅ Manajemen Profil
8. ✅ Manajemen Pengguna

#### TESTING YANG TELAH DILAKUKAN:
✅ Semua endpoint API berfungsi dengan benar
✅ Validasi error handling berfungsi
✅ Mekanisme keamanan berjalan sesuai spesifikasi
✅ Absensi siswa dengan QR code berhasil
✅ Status absensi kelas berhasil
✅ Penanganan berbagai skenario error berhasil

### CHECKPOINT INI MENANDAKAN:
✅ Backend API SiPresensi telah selesai dan siap untuk integrasi frontend
✅ Semua fitur inti sesuai PRD telah diimplementasikan
✅ Sistem siap untuk tahap pengembangan berikutnya

## 7. File-file Penting dan Catatan Khusus

### 7.1. File Dokumentasi & Konfigurasi Utama
- `PRD_SystemArchitecture_Sipresensi.txt` - Product Requirements Document dan arsitektur sistem.
- `Database_Sipresensi_Final.sql` - File SQL untuk membuat struktur database yang benar.
- `api_documentation_updated.md` - Dokumentasi lengkap API.
- `api_student_attendance.md` - Dokumentasi API khusus absensi siswa.
- `qr_code_mechanism.md` - Dokumentasi mekanisme QR code.
- `run_scheduler.bat` - Script batch untuk menjalankan scheduler QR code.

### 7.2. Catatan Penting
- Database **harus** dibuat menggunakan struktur dari `Database_Sipresensi_Final.sql`.
- Tabel `student_qr_cards` **harus** ada agar fitur absensi siswa berfungsi. Jika tidak ada, buat dengan SQL berikut:
  ```sql
  CREATE TABLE student_qr_cards (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      student_id BIGINT NOT NULL,
      qr_code VARCHAR(255) NOT NULL UNIQUE,
      is_active BOOLEAN DEFAULT TRUE,
      generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX idx_student_id (student_id),
      INDEX idx_qr_code (qr_code),
      INDEX idx_is_active (is_active),
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
  );
  ```
  Dan tambahkan data:
  ```sql
  INSERT INTO student_qr_cards (student_id, qr_code) VALUES (1, '1001'), (2, '1002'), (3, '1003');
  ```

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
   - Jalankan `run_scheduler.bat` untuk mengaktifkan generator token QR dinamis setiap 10 detik.

4. **Gunakan API sesuai dokumentasi.**

5. **(Opsional) Generate QR Code Siswa:**
   - Jika perlu generate ulang QR code siswa, jalankan: `php artisan student-qr:generate` (jika command ini ada).

---
*File ini dibuat untuk menyediakan snapshot cepat dari status dan konfigurasi project SiPresensi.*