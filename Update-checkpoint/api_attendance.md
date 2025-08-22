# Dokumentasi API Absensi Pegawai/Guru/Kepsek

## Attendance Endpoints

### POST /api/attendance/checkin
**Deskripsi:** Absen masuk pegawai/guru/kepsek
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_token": "string",
  "latitude": "float",
  "longitude": "float",
  "accuracy": "float (optional)",
  "photo": "string (base64 encoded image, optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen masuk berhasil",
  "data": {
    "id": 8,
    "user_id": 8,
    "type": "checkin",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
    "status": "hadir",
    "timestamp": "2025-08-21T10:29:30.000000Z",
    "date_only": "2025-08-21",
    "synced": true,
    "created_at": "2025-08-21T10:29:30.000000Z"
  }
}
```

**Response Gagal (Validasi):**
```json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": {
    // Detail error validasi
  }
}
```

**Response Gagal (QR token tidak valid):**
```json
{
  "success": false,
  "message": "QR token tidak valid atau sudah kadaluarsa"
}
```

**Response Gagal (Lokasi di luar area):**
```json
{
  "success": false,
  "message": "Anda berada di luar area sekolah"
}
```

**Response Gagal (Sudah absen):**
```json
{
  "success": false,
  "message": "Anda sudah melakukan absen masuk hari ini"
}
```

### POST /api/attendance/checkout
**Deskripsi:** Absen keluar pegawai/guru/kepsek
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_token": "string",
  "latitude": "float",
  "longitude": "float",
  "accuracy": "float (optional)",
  "photo": "string (base64 encoded image, optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen keluar berhasil",
  "data": {
    "id": 9,
    "user_id": 8,
    "type": "checkout",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
    "status": "hadir",
    "timestamp": "2025-08-21T16:30:00.000000Z",
    "date_only": "2025-08-21",
    "synced": true,
    "created_at": "2025-08-21T16:30:00.000000Z"
  }
}
```

**Response Gagal (Validasi):**
```json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": {
    // Detail error validasi
  }
}
```

**Response Gagal (QR token tidak valid):**
```json
{
  "success": false,
  "message": "QR token tidak valid atau sudah kadaluarsa"
}
```

**Response Gagal (Lokasi di luar area):**
```json
{
  "success": false,
  "message": "Anda berada di luar area sekolah"
}
```

**Response Gagal (Belum absen masuk):**
```json
{
  "success": false,
  "message": "Anda belum melakukan absen masuk hari ini"
}
```

**Response Gagal (Sudah absen keluar):**
```json
{
  "success": false,
  "message": "Anda sudah melakukan absen keluar hari ini"
}
```

### GET /api/attendance/history
**Deskripsi:** Mendapatkan riwayat absensi
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `start_date`: YYYY-MM-DD (optional)
- `end_date`: YYYY-MM-DD (optional)
- `per_page`: integer (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 8,
        "user_id": 8,
        "type": "checkin",
        "latitude": "-6.12345600",
        "longitude": "106.87654300",
        "accuracy": 50,
        "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
        "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
        "status": "hadir",
        "timestamp": "2025-08-21T10:29:30.000000Z",
        "date_only": "2025-08-21",
        "synced": true,
        "created_at": "2025-08-21T10:29:30.000000Z"
      }
    ],
    "first_page_url": "http://127.0.0.1:8000/api/attendance/history?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/attendance/history?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/attendance/history",
    "per_page": 15,
    "prev_page_url": null,
    "to": 1,
    "total": 1
  }
}
```

**Response Gagal (Akses Ditolak):**
```json
{
  "success": false,
  "message": "Anda tidak memiliki izin untuk mengakses riwayat absensi"
}
```