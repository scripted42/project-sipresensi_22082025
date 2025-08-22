# Dokumentasi API Student QR Cards

## Student QR Cards Endpoints

### GET /api/student-qr-cards
**Deskripsi:** Mendapatkan semua QR card siswa
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "student_id": 1,
      "qr_code": "ABC123XYZ",
      "is_active": true,
      "generated_at": "2025-08-22 10:30:00",
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00",
      "student": {
        "id": 1,
        "nisn_nip_nik": "1001",
        "name": "Andi Pratama",
        // ... data siswa lainnya
      }
    }
    // ... daftar QR card lainnya
  ]
}
```

**Response Gagal (Akses Ditolak):**
```json
{
  "success": false,
  "message": "Hanya admin atau kepala sekolah yang dapat mengakses data QR card siswa"
}
```

### GET /api/student-qr-cards/{id}
**Deskripsi:** Mendapatkan QR card siswa berdasarkan ID
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "student_id": 1,
    "qr_code": "ABC123XYZ",
    "is_active": true,
    "generated_at": "2025-08-22 10:30:00",
    "created_at": "2025-08-22 10:30:00",
    "updated_at": "2025-08-22 10:30:00",
    "student": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data siswa lainnya
    }
  }
}
```

**Response Gagal (QR Card tidak ditemukan):**
```json
{
  "success": false,
  "message": "QR card dengan ID tersebut tidak ditemukan"
}
```

### POST /api/student-qr-cards/generate
**Deskripsi:** Mengenerate QR code baru untuk seorang siswa
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "student_id": "integer"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "QR card baru berhasil di-generate",
  "data": {
    "id": 2,
    "student_id": 1,
    "qr_code": "XYZ789ABC",
    "is_active": true,
    "generated_at": "2025-08-22 11:00:00",
    "created_at": "2025-08-22 11:00:00",
    "updated_at": "2025-08-22 11:00:00",
    "student": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data siswa lainnya
    }
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

### PUT /api/student-qr-cards/{id}/status
**Deskripsi:** Memperbarui status QR card (aktif/tidak aktif)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "is_active": "boolean"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Status QR card berhasil diperbarui",
  "data": {
    "id": 1,
    "student_id": 1,
    "qr_code": "ABC123XYZ",
    "is_active": false,
    "generated_at": "2025-08-22 10:30:00",
    "created_at": "2025-08-22 10:30:00",
    "updated_at": "2025-08-22 11:15:00",
    "student": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data siswa lainnya
    }
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