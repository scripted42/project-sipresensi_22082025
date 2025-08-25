# Pengembangan Aplikasi SiPresensi Mobile

## Struktur Aplikasi

Aplikasi SiPresensi Mobile telah dibuat dengan struktur direktori sebagai berikut:

```
lib/
├── main.dart
├── core/
│   ├── models/
│   │   ├── user.dart
│   │   ├── dashboard.dart
│   │   └── attendance.dart
│   ├── network/
│   │   └── api_client.dart
│   ├── theme/
│   ├── routing/
│   ├── storage/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── auth_service.dart
│   │   └── login_screen.dart
│   ├── dashboard/
│   │   ├── dashboard_service.dart
│   │   └── dashboard_screen.dart
│   ├── attendance/
│   │   ├── student_attendance_service.dart
│   │   └── student_attendance_screen.dart
│   ├── scanner/
│   ├── leave/
│   ├── profile/
│   │   └── profile_screen.dart
│   ├── announcement/
│   └── user_management/
└── shared/
    ├── widgets/
    │   └── bottom_navigation.dart
    └── constants/
```

## Fitur yang Telah Diimplementasikan

1. **Autentikasi**
   - Login dengan NISN/NIP/NIK dan password
   - Penyimpanan token menggunakan shared_preferences
   - Navigasi ke halaman utama setelah login berhasil

2. **Dashboard**
   - Menampilkan informasi pengguna
   - Menampilkan statistik absensi (untuk guru)
   - Menampilkan pengumuman terbaru
   - Menampilkan izin terbaru

3. **Absensi Siswa**
   - Absensi individual dengan input NISN/NIP/NIK
   - Absensi massal per kelas
   - Pemilihan kelas dari daftar kelas yang tersedia

4. **Profil Pengguna**
   - Menampilkan informasi profil pengguna
   - Menampilkan peran pengguna
   - Fungsi logout

5. **Navigasi**
   - Bottom navigation bar untuk navigasi antar halaman
   - Navigasi antara Dashboard, Absensi, dan Profil

## Dependensi yang Digunakan

- `http`: Untuk melakukan request HTTP ke API
- `shared_preferences`: Untuk menyimpan token dan data pengguna
- `flutter_svg`: Untuk menampilkan gambar SVG
- `geolocator`: Untuk mendapatkan lokasi pengguna
- `camera`: Untuk mengambil foto
- `mobile_scanner`: Untuk memindai QR code
- `file_picker`: Untuk memilih file
- `table_calendar`: Untuk menampilkan kalender
- `animations`: Untuk animasi
- `carousel_slider`: Untuk slider carousel
- `flutter_quill`: Untuk editor teks kaya
- `flutter_offline`: Untuk deteksi koneksi offline
- `hive`: Untuk penyimpanan lokal
- `flutter_secure_storage`: Untuk penyimpanan aman
- `google_fonts`: Untuk font Google

## Rencana Pengembangan Selanjutnya

1. **Implementasi Fitur QR Code Scanner**
   - Mengintegrasikan mobile_scanner untuk memindai QR code siswa
   - Menambahkan fungsi verifikasi QR code dinamis

2. **Implementasi Fitur Geolokasi**
   - Mengintegrasikan geolocator untuk verifikasi lokasi
   - Menambahkan pengecekan radius 100 meter dari sekolah

3. **Implementasi Fitur Kamera**
   - Mengintegrasikan camera untuk mengambil foto selfie
   - Menambahkan fungsi pengambilan foto saat absensi

4. **Implementasi Manajemen Izin**
   - Membuat halaman untuk mengajukan izin
   - Membuat halaman untuk melihat riwayat izin
   - Menambahkan fungsi persetujuan izin (untuk kepala sekolah/admin)

5. **Implementasi Pengumuman**
   - Membuat halaman untuk melihat pengumuman
   - Menambahkan fungsi pembuatan/edit/hapus pengumuman (untuk admin/kepsek)

6. **Implementasi Manajemen Pengguna**
   - Membuat halaman untuk melihat daftar pengguna (untuk admin)
   - Menambahkan fungsi tambah/edit/hapus pengguna (untuk admin)

7. **Implementasi Mode Offline**
   - Menambahkan penyimpanan lokal untuk data absensi
   - Menambahkan fungsi sinkronisasi data ketika koneksi tersedia

8. **Enhancement UI/UX**
   - Menambahkan animasi transisi antar halaman
   - Meningkatkan desain tampilan dengan Material 3
   - Menambahkan theme switching (light/dark mode)

9. **Testing dan Debugging**
   - Menambahkan unit test untuk setiap service
   - Melakukan integration testing dengan API backend
   - Memperbaiki bug yang ditemukan selama testing

10. **Deployment**
    - Membuat build aplikasi untuk Android
    - Menguji aplikasi di berbagai perangkat
    - Menyiapkan distribusi aplikasi (Google Play Store)

## Instruksi Menjalankan Aplikasi

1. Pastikan Flutter SDK telah terinstal
2. Jalankan `flutter pub get` untuk menginstal dependensi
3. Jalankan `flutter run` untuk menjalankan aplikasi di emulator atau perangkat fisik

## Catatan Penting

- Aplikasi ini dirancang untuk berkomunikasi dengan backend Laravel yang berjalan di `http://10.0.2.2:8000` (alamat default untuk emulator Android mengakses localhost)
- Pastikan backend telah berjalan sebelum menjalankan aplikasi
- Untuk pengujian di perangkat fisik, ubah baseUrl di `lib/core/network/api_client.dart` sesuai dengan alamat IP backend