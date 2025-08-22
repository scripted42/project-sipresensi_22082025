# Struktur Proyek SiPresensi v.1.1

## Struktur Direktori Utama
```
SiPresensi-v.1.1/
├── Database_Sipresensi.sql
├── Database_Sipresensi_Complete.sql
├── Database_Sipresensi_Final.sql
├── PRD_SystemArchitecture_Sipresensi.txt
├── api_development_plan.md
├── api_documentation.md
├── api_endpoints.md
├── complete_api_documentation.md
├── final_steps.txt
├── mark_last_migration.sql
├── next_steps.md
├── progress_fix.txt
├── progress_fix_updated.txt
├── sipresensi-backend/
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/
│   │   │   │   ├── API/
│   │   │   │   │   ├── AuthController.php
│   │   │   │   │   ├── AttendanceController.php
│   │   │   │   │   ├── LeaveController.php
│   │   │   │   │   ├── AnnouncementController.php
│   │   │   │   │   ├── ProfileController.php
│   │   │   │   │   ├── QRCodeController.php
│   │   │   │   │   └── UserController.php
│   │   │   │   └── Controller.php
│   │   │   ├── Middleware/
│   │   │   │   ├── TrimStrings.php
│   │   │   │   └── TrustProxies.php
│   │   │   └── Kernel.php
│   │   ├── Models/
│   │   │   ├── User.php
│   │   │   ├── Role.php
│   │   │   ├── Class.php
│   │   │   ├── StudentClass.php
│   │   │   ├── Attendance.php
│   │   │   ├── DynamicQRToken.php
│   │   │   ├── Leave.php
│   │   │   ├── Announcement.php
│   │   │   ├── Setting.php
│   │   │   ├── OfflineSyncLog.php
│   │   │   └── PersonalAccessToken.php
│   │   └── Providers/
│   │       ├── AppServiceProvider.php
│   │       └── RouteServiceProvider.php
│   ├── bootstrap/
│   │   └── app.php
│   ├── config/
│   │   ├── app.php
│   │   ├── auth.php
│   │   ├── broadcasting.php
│   │   ├── cache.php
│   │   ├── cors.php
│   │   ├── database.php
│   │   ├── filesystems.php
│   │   ├── hashing.php
│   │   ├── logging.php
│   │   ├── mail.php
│   │   ├── queue.php
│   │   ├── sanctum.php
│   │   ├── services.php
│   │   └── session.php
│   ├── database/
│   │   ├── factories/
│   │   ├── migrations/
│   │   └── seeders/
│   ├── public/
│   │   ├── index.php
│   │   └── .htaccess
│   ├── resources/
│   │   └── views/
│   │       └── welcome.blade.php
│   ├── routes/
│   │   ├── api.php
│   │   ├── console.php
│   │   └── web.php
│   ├── storage/
│   │   ├── app/
│   │   ├── framework/
│   │   └── logs/
│   ├── tests/
│   │   ├── Feature/
│   │   ├── Unit/
│   │   └── CreatesApplication.php
│   ├── vendor/
│   └── .env
├── sipresensi-mobile-fix/
└── Software/
```

## API Endpoints

### Auth Endpoints:
- `POST /api/auth/login` - Login pengguna
- `POST /api/auth/logout` - Logout pengguna

### Attendance Endpoints:
- `POST /api/attendance/checkin` - Absen masuk
- `POST /api/attendance/checkout` - Absen keluar
- `GET /api/attendance/history` - Riwayat absensi

### Leave Endpoints:
- `GET /api/leaves` - Daftar pengajuan izin
- `POST /api/leaves` - Buat pengajuan izin baru
- `GET /api/leaves/{id}` - Detail pengajuan izin
- `PUT /api/leaves/{id}` - Ubah pengajuan izin
- `DELETE /api/leaves/{id}` - Hapus pengajuan izin

### Announcement Endpoints:
- `GET /api/announcements` - Daftar pengumuman
- `POST /api/announcements` - Buat pengumuman baru
- `GET /api/announcements/{id}` - Detail pengumuman
- `PUT /api/announcements/{id}` - Ubah pengumuman
- `DELETE /api/announcements/{id}` - Hapus pengumuman

### Profile Endpoints:
- `GET /api/profile` - Data profil pengguna
- `PUT /api/profile` - Ubah data profil
- `PUT /api/profile/password` - Ubah password

### QR Code Endpoints:
- `GET /api/qrcode/dynamic` - Token QR Code dinamis

### User Management Endpoints:
- `GET /api/users` - Daftar pengguna (admin only)
- `POST /api/users` - Buat pengguna baru (admin only)
- `GET /api/users/{id}` - Detail pengguna (admin only)
- `PUT /api/users/{id}` - Ubah pengguna (admin only)
- `DELETE /api/users/{id}` - Hapus pengguna (admin only)

## Database Tables

### Core Tables:
1. `users` - Data pengguna
2. `roles` - Peran pengguna
3. `classes` - Kelas sekolah
4. `student_class` - Relasi siswa-kelas
5. `attendance` - Catatan absensi
6. `dynamic_qr_tokens` - QR Code dinamis
7. `leaves` - Pengajuan izin
8. `announcements` - Pengumuman
9. `settings` - Konfigurasi sistem
10. `offline_sync_log` - Log sinkronisasi offline
11. `personal_access_tokens` - Token autentikasi API
12. `migrations` - Tracking migrasi database

## Teknologi yang Digunakan

### Backend:
- Laravel 12.25.0 (PHP Framework)
- MySQL (Database)
- Laravel Sanctum (API Authentication)
- REST API Architecture

### Frontend:
- React Native (Mobile App)
- Tamagui (UI Framework)
- Expo (Development Platform)

### Infrastruktur:
- XAMPP (Apache + MySQL + PHP)
- phpMyAdmin (Database Management)

## Cara Menjalankan Proyek

1. **Setup Database:**
   - Jalankan XAMPP dan aktifkan Apache dan MySQL
   - Buat database `sipresensi` melalui phpMyAdmin
   - Impor file `Database_Sipresensi_Final.sql` ke database tersebut

2. **Setup Backend:**
   - Masuk ke direktori `sipresensi-backend`
   - Jalankan perintah:
     ```
     composer install
     php artisan key:generate
     php artisan config:cache
     php artisan route:cache
     php artisan serve
     ```

3. **Setup Mobile App:**
   - Masuk ke direktori `sipresensi-mobile-fix`
   - Jalankan perintah:
     ```
     npm install
     expo start
     ```

4. **Testing API:**
   - Gunakan Postman atau curl untuk menguji endpoint API
   - Contoh login:
     ```
     curl -X POST http://127.0.0.1:8000/api/auth/login -H "Content-Type: application/json" -d "{\"nisn_nip_nik\": \"1001\", \"password\": \"password\"}"
     ```

## Catatan Penting

1. **Autentikasi API:** Gunakan Laravel Sanctum dengan token Bearer
2. **QR Code Dinamis:** Token QR berganti setiap 10 detik
3. **Verifikasi Lokasi:** Absensi memerlukan verifikasi lokasi GPS dalam radius 100 meter dari sekolah
4. **Foto Selfie:** Absensi memerlukan foto selfie
5. **Role-Based Access Control:** Berbagai level akses untuk siswa, guru, pegawai, kepala sekolah, dan admin