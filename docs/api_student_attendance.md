# Dokumentasi API Student Attendance

## Student Attendance Endpoints

### POST /api/student-attendance/scan-qr
**Deskripsi:** Scan QR code siswa atau masukkan NISN/NIP/NIK secara manual untuk absensi (dioptimalkan untuk kecepatan)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_code": "string (optional*)",
  "nisn_nip_nik": "string (optional*)",
  "class_id": "integer",
  "latitude": "float",
  "longitude": "float",
  "accuracy": "float (optional)",
  "photo": "string (optional, base64 encoded image)"
}
```
*Harus menyediakan salah satu dari `qr_code` atau `nisn_nip_nik`.

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

**Response Gagal (Validasi input):**
```json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": {
    // Detail error validasi
  }
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

**Response Gagal (Siswa tidak ditemukan - input manual):**
```json
{
  "success": false,
  "message": "Siswa dengan NISN/NIP/NIK tersebut tidak ditemukan."
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

### POST /api/student-attendance/bulk
**Deskripsi:** Melakukan absensi massal untuk semua siswa dalam satu kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "class_id": "integer",
  "date": "string (YYYY-MM-DD, optional, default: hari ini)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absensi massal berhasil diproses",
  "data": {
    "class_id": 1,
    "date": "2023-10-27",
    "total_students": 30,
    "already_attended": 5,
    "newly_attended": 25,
    "processed_students": [
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
      // ... daftar semua siswa dalam kelas
    ]
  }
}
```

**Response Gagal (Validasi input):**
```json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": {
    // Detail error validasi
  }
}
```

**Response Gagal (Tidak ada siswa dalam kelas):**
```json
{
  "success": false,
  "message": "Tidak ada siswa terdaftar di kelas ini"
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