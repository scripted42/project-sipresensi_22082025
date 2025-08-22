# Dokumentasi API Settings

## Settings Endpoints

### GET /api/settings
**Deskripsi:** Mendapatkan semua pengaturan sistem
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": [
    {
      "key_name": "attendance_radius",
      "value": "100",
      "description": "Radius absensi dalam meter",
      "updated_at": "2025-08-22 10:30:00"
    },
    {
      "key_name": "school_latitude",
      "value": "-6.123456",
      "description": "Koordinat latitude sekolah",
      "updated_at": "2025-08-22 10:30:00"
    }
    // ... daftar semua pengaturan
  ]
}
```

**Response Gagal (Akses Ditolak):**
```json
{
  "success": false,
  "message": "Hanya admin yang dapat mengakses pengaturan sistem"
}
```

### GET /api/settings/{key}
**Deskripsi:** Mendapatkan pengaturan sistem berdasarkan key
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "key_name": "attendance_radius",
    "value": "100",
    "description": "Radius absensi dalam meter",
    "updated_at": "2025-08-22 10:30:00"
  }
}
```

**Response Gagal (Setting tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengaturan dengan key tersebut tidak ditemukan"
}
```

### PUT /api/settings/{key}
**Deskripsi:** Memperbarui pengaturan sistem berdasarkan key
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "value": "string",
  "description": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengaturan berhasil diperbarui",
  "data": {
    "key_name": "attendance_radius",
    "value": "150",
    "description": "Radius absensi dalam meter",
    "updated_at": "2025-08-22 11:00:00"
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

### PUT /api/settings/bulk-update
**Deskripsi:** Memperbarui banyak pengaturan sekaligus
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "settings": [
    {
      "key": "string",
      "value": "string"
    },
    {
      "key": "string",
      "value": "string"
    }
  ]
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengaturan berhasil diperbarui",
  "data": [
    {
      "key_name": "attendance_radius",
      "value": "150",
      "description": "Radius absensi dalam meter",
      "updated_at": "2025-08-22 11:00:00"
    },
    {
      "key_name": "checkin_end",
      "value": "08:00:00",
      "description": "Batas waktu check-in",
      "updated_at": "2025-08-22 11:00:00"
    }
  ]
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