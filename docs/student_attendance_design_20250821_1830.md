# Desain Mekanisme Absensi Siswa Berdasarkan Penjelasan
Tanggal: Thursday, August 21, 2025
Waktu: 18:30 WIB

## Kebutuhan Khusus Absensi Siswa

### Karakteristik Sistem:
- 10 guru melakukan scanning
- 1000 siswa dengan QR code di kartu pelajar
- Perlu mekanisme scanning cepat
- UI dengan indikator visual (hijau/merah)

### Mekanisme yang Akan Diimplementasikan:

1. **QR Code Generator untuk Siswa (Admin Only)**
   - Admin membuat QR code statis untuk setiap siswa
   - QR code berisi NISN/NIP/NIK siswa
   - QR code dicetak dan ditempel di kartu pelajar

2. **Scanner Optimized untuk Guru**
   - Endpoint khusus untuk scanning QR code siswa
   - Validasi cepat tanpa delay berlebihan
   - Respon langsung dengan status (sukses/gagal)
   - UI feedback langsung (kotak hijau/merah)

3. **Endpoint API yang Diperlukan**
   - POST /api/student-attendance/scan-qr
   - POST /api/student-attendance/bulk-scan
   - GET /api/student-attendance/class-status/{class_id}

4. **UI Indicators**
   - Kotak hijau: Absensi berhasil
   - Kotak merah: Absensi gagal
   - Menampilkan NISN, nama, dan status absen

## Implementasi Teknis:

### Database:
- Tabel student_qr_cards:
  - student_id (foreign key ke users)
  - qr_code (unik untuk setiap siswa)
  - is_active (boolean)
  - generated_at (timestamp)

### API Endpoints:
1. **Scan QR Siswa**:
   - POST /api/student-attendance/scan-qr
   - Input: qr_code, class_id, latitude, longitude, photo
   - Output: {success: true/false, student: {nisn, name}, message}

2. **Bulk Scan untuk Kelas**:
   - POST /api/student-attendance/bulk-scan
   - Untuk multiple scan dalam satu sesi

3. **Status Kelas**:
   - GET /api/student-attendance/class-status/{class_id}?date=YYYY-MM-DD
   - Menampilkan status absensi semua siswa dalam kelas

### Optimasi Performa:
- Caching data siswa per kelas
- Indexing pada tabel student_qr_cards
- Validasi ringan dan cepat
- Response JSON minimal untuk kecepatan