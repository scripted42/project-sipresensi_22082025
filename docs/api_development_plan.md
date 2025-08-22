# Rencana Pengembangan API SiPresensi

## Status Saat Ini:
- AuthController sudah ada dengan endpoint:
  - POST /api/auth/login
  - POST /api/auth/logout
  - GET /api/user

## Controller yang Perlu Dibuat:
1. AttendanceController
2. LeaveController
3. AnnouncementController
4. ProfileController
5. QRCodeController
6. UserController (untuk admin)

## Tahapan Pengembangan:

### Tahap 1: Membuat Controller
1. AttendanceController - untuk fitur absensi
2. LeaveController - untuk fitur pengajuan izin
3. AnnouncementController - untuk fitur pengumuman
4. ProfileController - untuk manajemen profil
5. QRCodeController - untuk QR Code dinamis
6. UserController - untuk manajemen pengguna (admin)

### Tahap 2: Menambahkan Route
Setelah controller dibuat, tambahkan route di routes/api.php

### Tahap 3: Mengimplementasi Method
Implementasi method-method dalam setiap controller sesuai dengan kebutuhan

### Tahap 4: Pengujian
Uji setiap endpoint yang telah dibuat

## Prioritas Pengembangan:
Berdasarkan PRD, berikut adalah prioritas pengembangan:

1. AttendanceController (fitur inti)
2. LeaveController (fitur penting)
3. AnnouncementController (komunikasi)
4. ProfileController (manajemen akun)
5. QRCodeController (keamanan)
6. UserController (admin)