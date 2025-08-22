# Dokumentasi API Pengumuman

## Announcements Endpoints

### GET /api/announcements
**Deskripsi:** Mendapatkan daftar pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `per_page`: integer (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengumuman berhasil diambil",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "title": "Jadwal Ujian Tengah Semester",
        "content": "UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.",
        "author_id": 4,
        "is_published": true,
        "published_at": "2025-08-21T08:54:58.000000Z",
        "created_at": "2025-08-21T08:54:58.000000Z",
        "updated_at": "2025-08-21T08:54:58.000000Z"
      }
    ],
    "first_page_url": "http://127.0.0.1:8000/api/announcements?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/announcements?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/announcements",
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
  "message": "Anda tidak memiliki izin untuk mengakses pengumuman"
}
```

### POST /api/announcements
**Deskripsi:** Membuat pengumuman baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "title": "string",
  "content": "string",
  "is_published": "boolean (optional, default: true)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil dibuat",
  "data": {
    "title": "Pengumuman Tes",
    "content": "Ini adalah pengumuman tes untuk pengujian sistem",
    "author_id": 8,
    "is_published": true,
    "published_at": null,
    "updated_at": "2025-08-21T10:15:43.000000Z",
    "created_at": "2025-08-21T10:15:43.000000Z",
    "id": 3
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

### GET /api/announcements/{id}
**Deskripsi:** Mendapatkan detail pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengumuman berhasil diambil",
  "data": {
    "id": 1,
    "title": "Jadwal Ujian Tengah Semester",
    "content": "UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.",
    "author_id": 4,
    "is_published": true,
    "published_at": "2025-08-21T08:54:58.000000Z",
    "created_at": "2025-08-21T08:54:58.000000Z",
    "updated_at": "2025-08-21T08:54:58.000000Z"
  }
}
```

**Response Gagal (Pengumuman tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengumuman dengan ID tersebut tidak ditemukan"
}
```

### PUT /api/announcements/{id}
**Deskripsi:** Memperbarui pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "title": "string (optional)",
  "content": "string (optional)",
  "is_published": "boolean (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil diperbarui",
  "data": {
    "id": 3,
    "title": "Pengumuman Tes - Updated",
    "content": "Ini adalah pengumuman tes untuk pengujian sistem - Updated",
    "author_id": 8,
    "is_published": true,
    "published_at": null,
    "updated_at": "2025-08-21T10:20:00.000000Z",
    "created_at": "2025-08-21T10:15:43.000000Z"
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

**Response Gagal (Pengumuman tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengumuman dengan ID tersebut tidak ditemukan"
}
```

### DELETE /api/announcements/{id}
**Deskripsi:** Menghapus pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil dihapus"
}
```

**Response Gagal (Pengumuman tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengumuman dengan ID tersebut tidak ditemukan"
}
```