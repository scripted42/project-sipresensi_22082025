# Dokumentasi API Offline Sync

## Offline Sync Endpoints

### GET /api/offline-sync
**Deskripsi:** Mendapatkan semua log sinkronisasi offline dengan filter dan pagination
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `user_id`: Filter berdasarkan ID user
- `status`: Filter berdasarkan status ('pending', 'success', 'failed')
- `action_type`: Filter berdasarkan tipe action
- `per_page`: Jumlah data per halaman (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "user_id": 1,
        "action_type": "attendance",
        "data": {
          "type": "checkin",
          "timestamp": "2025-04-05 07:25:00"
        },
        "synced_at": "2025-04-05 07:25:00",
        "status": "success",
        "error_message": null,
        "user": {
          "id": 1,
          "nisn_nip_nik": "1001",
          "name": "Andi Pratama",
          // ... data user lainnya
        }
      }
      // ... data log lainnya
    ],
    "first_page_url": "http://127.0.0.1:8000/api/offline-sync?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/offline-sync?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/offline-sync",
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
  "message": "Hanya admin atau kepala sekolah yang dapat mengakses log sinkronisasi"
}
```

### GET /api/offline-sync/{id}
**Deskripsi:** Mendapatkan log sinkronisasi offline berdasarkan ID
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "user_id": 1,
    "action_type": "attendance",
    "data": {
      "type": "checkin",
      "timestamp": "2025-04-05 07:25:00"
    },
    "synced_at": "2025-04-05 07:25:00",
    "status": "success",
    "error_message": null,
    "user": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data user lainnya
    }
  }
}
```

**Response Gagal (Log tidak ditemukan):**
```json
{
  "success": false,
  "message": "Log sinkronisasi dengan ID tersebut tidak ditemukan"
}
```

### POST /api/offline-sync/process-attendance
**Deskripsi:** Memproses data absensi offline
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "attendances": [
    {
      "user_id": "integer",
      "type": "string (checkin|checkout)",
      "timestamp": "string (YYYY-MM-DD HH:MM:SS)",
      "latitude": "float (optional)",
      "longitude": "float (optional)",
      "accuracy": "float (optional)",
      "photo_path": "string (optional)"
    }
  ]
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Proses sinkronisasi data absensi selesai",
  "data": {
    "processed": [
      {
        "id": 2,
        "user_id": 1,
        "type": "checkin",
        "latitude": -6.123456,
        "longitude": 106.876543,
        "accuracy": 5.2,
        "photo_path": "attendance/andi_checkin_2.jpg",
        "qr_token_used": "OFFLINE",
        "status": "hadir",
        "timestamp": "2025-04-06 07:25:30",
        "date_only": "2025-04-06",
        "synced": true,
        "created_at": "2025-08-22 11:30:00"
      }
    ],
    "failed": [
      {
        "data": {
          "user_id": 2,
          "type": "checkin",
          "timestamp": "2025-04-06 07:25:30"
        },
        "error": "Absensi dengan timestamp yang sama sudah ada"
      }
    ],
    "processed_count": 1,
    "failed_count": 1
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

### POST /api/offline-sync/{id}/retry
**Deskripsi:** Mencoba ulang sinkronisasi log yang gagal
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Sinkronisasi berhasil diulang",
  "data": {
    "id": 2,
    "user_id": 1,
    "type": "checkin",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": 5.2,
    "photo_path": "attendance/andi_checkin_2.jpg",
    "qr_token_used": "OFFLINE_RETRY",
    "status": "hadir",
    "timestamp": "2025-04-06 07:25:30",
    "date_only": "2025-04-06",
    "synced": true,
    "created_at": "2025-08-22 11:35:00"
  }
}
```

**Response Gagal (Log tidak ditemukan):**
```json
{
  "success": false,
  "message": "Log sinkronisasi dengan ID tersebut tidak ditemukan"
}
```

**Response Gagal (Log tidak dapat diulang):**
```json
{
  "success": false,
  "message": "Hanya log dengan status failed yang dapat dicoba ulang"
}
```