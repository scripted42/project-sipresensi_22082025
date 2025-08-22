# Instruksi Setup Absensi Siswa

## Langkah-langkah Setup

1. **Jalankan Migration**
   ```bash
   cd sipresensi-backend
   php artisan migrate
   ```

2. **Generate QR Code untuk Semua Siswa**
   ```bash
   php artisan student-qr:generate
   ```

3. **Verifikasi Data QR Code**
   ```sql
   SELECT u.nisn_nip_nik, u.name, sqc.qr_code, sqc.is_active 
   FROM users u 
   JOIN student_qr_cards sqc ON u.id = sqc.student_id 
   WHERE u.role_id = 1 
   ORDER BY u.name;
   ```

## Endpoint API yang Tersedia

### Untuk Guru (Role ID: 2)
- `POST /api/student-attendance/scan-qr` - Scan QR code siswa
- `GET /api/student-attendance/class-status/{classId}` - Status absensi kelas

### Untuk Admin (Role ID: 5)
- Semua endpoint user management
- Generate ulang QR code siswa jika diperlukan

## Testing API

### Scan QR Siswa
```bash
curl -X POST http://127.0.0.1:8000/api/student-attendance/scan-qr \
  -H "Authorization: Bearer {token_guru}" \
  -H "Content-Type: application/json" \
  -d '{
    "qr_code": "1001",
    "class_id": 1,
    "latitude": -6.123456,
    "longitude": 106.876543
  }'
```

### Cek Status Kelas
```bash
curl -X GET http://127.0.0.1:8000/api/student-attendance/class-status/1 \
  -H "Authorization: Bearer {token_guru}" \
  -H "Content-Type: application/json"
```

## Catatan Penting

1. QR code siswa menggunakan NISN mereka sebagai kode
2. Setiap siswa hanya memiliki 1 QR code yang unik
3. QR code bisa di-generate ulang jika rusak/hilang
4. Hanya guru yang bisa melakukan scanning QR siswa
5. Sistem memverifikasi bahwa siswa ada di kelas yang diajarkan guru
6. Response dioptimalkan untuk kecepatan scanning