# Dokumentasi API SiPresensi - Endpoint yang Telah Diuji

## 1. Auth Endpoints

### POST /api/auth/login
**Deskripsi:** Login pengguna ke sistem
**Headers:** 
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "string",
  "password": "string"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "user": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "email": "andi@siswa.sch.id",
      "phone": "081234567890",
      "role_id": 1,
      "photo_path": "profiles/andi.jpg",
      "is_active": 1,
      "created_at": "2025-08-20T23:30:07.000000Z",
      "updated_at": "2025-08-20T23:30:07.000000Z"
    },
    "token": "1|umK7zuVmRiDQV7DoWvoB4bwmyPWV7v05MJE2H4lm2cd7c5e1"
  }
}
```

**Response Gagal:**
```json
{
  "success": false,
  "message": "Kredensial tidak valid"
}
```

### POST /api/auth/logout
**Deskripsi:** Logout pengguna dari sistem
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Logout berhasil"
}
```

## 2. User Endpoints

### GET /api/user
**Deskripsi:** Mendapatkan data pengguna yang sedang login
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data user berhasil diambil",
  "data": {
    "user": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "email": "andi@siswa.sch.id",
      "phone": "081234567890",
      "role_id": 1,
      "photo_path": "profiles/andi.jpg",
      "is_active": 1,
      "created_at": "2025-08-20T23:30:07.000000Z",
      "updated_at": "2025-08-20T23:30:07.000000Z"
    }
  }
}
```

## 3. QR Code Endpoints

### GET /api/qrcode/dynamic
**Deskripsi:** Mendapatkan token QR code dinamis yang masih valid
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Token QR dinamis berhasil diambil",
  "data": {
    "token": "a1b2c3d4e5f67890",
    "expires_at": "2025-04-05 07:30:00"
  }
}
```

**Response Gagal:**
```json
{
  "success": false,
  "message": "Terjadi kesalahan saat mengambil token QR dinamis"
}
```

### POST /api/qrcode/verify
**Deskripsi:** Memverifikasi token QR code dan mengirim data absensi lengkap
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_token": "string",
  "user_id": "integer",
  "latitude": "float",
  "longitude": "float",
  "photo": "string (base64 encoded image)",
  "type": "string (checkin|checkout)"
}
```

**Response Sukses (Checkin):**
```json
{
  "success": true,
  "message": "Absen masuk berhasil",
  "data": {
    "id": 1,
    "user_id": 1,
    "type": "checkin",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": 5.2,
    "photo_path": "attendance/andi_checkin_1.jpg",
    "qr_token_used": "QRX9B2M8P1",
    "timestamp": "2025-04-05 07:25:30",
    "created_at": "2025-04-05T07:25:30.000000Z",
    "updated_at": "2025-04-05T07:25:30.000000Z"
  }
}
```

**Response Sukses (Checkout):**
```json
{
  "success": true,
  "message": "Absen keluar berhasil",
  "data": {
    "id": 2,
    "user_id": 1,
    "type": "checkout",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": 5.2,
    "photo_path": "attendance/andi_checkout_1.jpg",
    "qr_token_used": "QRX9B2M8P1",
    "timestamp": "2025-04-05 15:30:30",
    "created_at": "2025-04-05T15:30:30.000000Z",
    "updated_at": "2025-04-05T15:30:30.000000Z"
  }
}
```

**Response Gagal (QR Token Invalid):**
```json
{
  "success": false,
  "message": "QR token tidak valid atau sudah kadaluarsa"
}
```

**Response Gagal (Lokasi Invalid):**
```json
{
  "success": false,
  "message": "Anda berada di luar area sekolah"
}
```

**Response Gagal (Sudah Absen):**
```json
{
  "success": false,
  "message": "Anda sudah melakukan absen masuk hari ini"
}
```

## 4. Student Attendance Endpoints

### POST /api/student-attendance/scan-qr
**Deskripsi:** Scan QR code siswa untuk absensi (dioptimalkan untuk kecepatan)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_code": "string",
  "class_id": "integer",
  "latitude": "float",
  "longitude": "float",
  "photo": "string (optional, base64 encoded image)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "student": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama"
  },
  "message": "Absensi berhasil"
}
```

**Response Gagal (QR tidak valid):**
```json
{
  "success": false,
  "student": null,
  "message": "QR code tidak valid"
}
```

**Response Gagal (Sudah absen):**
```json
{
  "success": false,
  "student": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama"
  },
  "message": "Sudah absen hari ini"
}
```

### GET /api/student-attendance/class-status/{classId}
**Deskripsi:** Mendapatkan status absensi semua siswa dalam kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- date: YYYY-MM-DD (optional, default: hari ini)

**Response Sukses:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "attended": true
    },
    {
      "id": 2,
      "nisn_nip_nik": "1002",
      "name": "Budi Santoso",
      "attended": false
    }
  ]
}
```

## Catatan Penting:
1. Semua endpoint auth (kecuali login) memerlukan token autentikasi di header Authorization
2. Token didapatkan setelah login berhasil dan harus disimpan untuk digunakan dalam request selanjutnya
3. Setelah logout, token tidak lagi valid dan pengguna harus login ulang untuk mendapatkan token baru
4. Token QR code dinamis hanya berlaku selama 10 detik
5. Verifikasi lokasi dilakukan dengan radius 100 meter dari lokasi sekolah
6. Pengguna harus absen masuk sebelum bisa absen keluar
7. Hanya guru yang dapat mengakses endpoint student attendance