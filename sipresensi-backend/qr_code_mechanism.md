# Dokumentasi Mekanisme QR Code Dinamis untuk Absensi

## Gambaran Umum

Sistem QR code dinamis untuk absensi dirancang untuk memastikan keamanan dan akurasi proses absensi di sekolah. QR code yang ditampilkan di monitor depan sekolah akan berubah setiap 10 detik, sehingga hanya bisa digunakan untuk absensi dalam waktu yang sangat singkat.

## Komponen Sistem

### 1. Database
- Tabel `dynamic_qr_tokens`: Menyimpan token QR code yang digenerate secara dinamis
- Tabel `attendance`: Menyimpan data absensi lengkap dengan referensi ke token QR yang digunakan

### 2. Backend (Laravel)
- **Model**: `DynamicQRToken`, `Attendance`
- **Controller**: `QRCodeController`
- **Command**: `GenerateDynamicQRToken`
- **Scheduler**: Menjalankan command setiap 10 detik

### 3. API Endpoints
- `GET /api/qrcode/dynamic`: Mendapatkan token QR code yang masih valid
- `POST /api/qrcode/verify`: Memverifikasi token QR dan menyimpan data absensi

## Cara Kerja

### 1. Generate Token QR Dinamis
Setiap 10 detik, sistem akan:
1. Menghapus token yang sudah kadaluarsa
2. Mengenerate token baru dengan masa aktif 10 detik
3. Menyimpan token ke database

### 2. Menampilkan QR Code di Monitor
Aplikasi frontend di monitor sekolah akan:
1. Memanggil endpoint `GET /api/qrcode/dynamic` setiap beberapa detik
2. Menampilkan QR code yang berisi token terbaru
3. QR code akan berubah setiap 10 detik sesuai dengan token baru

### 3. Proses Absensi di Mobile App
Ketika pengguna melakukan absensi:
1. Mobile app memindai QR code di monitor
2. Mendapatkan token dari QR code
3. Mengirim data ke endpoint `POST /api/qrcode/verify` dengan:
   - Token QR
   - ID pengguna
   - Koordinat GPS
   - Foto selfie (base64 encoded)
   - Tipe absensi (checkin/checkout)
4. Sistem memverifikasi:
   - Validitas token QR
   - Lokasi pengguna (radius 100 meter dari sekolah)
   - Status absensi pengguna hari ini
5. Jika semua valid, data absensi disimpan dan token ditandai sebagai sudah digunakan

## Setup dan Konfigurasi

### 1. Menjalankan Scheduler
Untuk menjalankan scheduler yang mengenerate token QR setiap 10 detik:

**Di Windows:**
```bash
# Jalankan script batch
cd E:\\Project Software House\\Deploy\\ReactNative2\\SiPresensi-v.1.1\\sipresensi-backend
run_scheduler.bat
```

**Di Linux/Unix:**
```bash
# Tambahkan ke crontab
* * * * * cd /path/to/sipresensi-backend && php artisan schedule:run >> /dev/null 2>&1
```

### 2. API Endpoints

#### Mendapatkan Token QR Dinamis
```bash
curl -X GET http://127.0.0.1:8000/api/qrcode/dynamic \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json"
```

#### Verifikasi QR dan Submit Absensi
```bash
curl -X POST http://127.0.0.1:8000/api/qrcode/verify \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "qr_token": "token_dari_qr_code",
    "user_id": 1,
    "latitude": -6.123456,
    "longitude": 106.876543,
    "photo": "base64_encoded_image_string",
    "type": "checkin"
  }'
```

## Keamanan

1. **Token Kadaluarsa**: Token QR hanya berlaku selama 10 detik
2. **Verifikasi Lokasi**: Sistem memverifikasi bahwa pengguna berada dalam radius 100 meter dari sekolah
3. **Token Sekali Pakai**: Setiap token hanya bisa digunakan sekali
4. **Autentikasi API**: Semua endpoint memerlukan token autentikasi