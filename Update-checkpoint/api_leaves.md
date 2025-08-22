# Dokumentasi API Manajemen Izin

## Leaves Endpoints

### GET /api/leaves
**Deskripsi:** Mendapatkan daftar izin (dengan filter)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `status`: menunggu|disetujui|ditolak (optional)
- `leave_type`: izin|cuti|dinas_luar|sakit (optional)
- `start_date`: YYYY-MM-DD (optional)
- `end_date`: YYYY-MM-DD (optional)
- `per_page`: integer (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengajuan izin berhasil diambil",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "user_id": 1,
        "leave_type": "sakit",
        "start_date": "2025-04-06T00:00:00.000000Z",
        "end_date": "2025-04-06T00:00:00.000000Z",
        "reason": "Demam tinggi, dokter sudah memberi surat.",
        "attachment_path": "leaves/surat_andi.pdf",
        "status": "disetujui",
        "approved_by": 4,
        "approval_comment": null,
        "approved_at": "2025-04-05T10:30:00.000000Z",
        "created_at": "2025-04-05T09:00:00.000000Z",
        "updated_at": "2025-04-05T10:30:00.000000Z"
      }
    ],
    "first_page_url": "http://127.0.0.1:8000/api/leaves?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/leaves?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/leaves",
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
  "message": "Anda tidak memiliki izin untuk mengakses data pengajuan izin"
}
```

### POST /api/leaves
**Deskripsi:** Mengajukan izin baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "leave_type": "string (izin|cuti|dinas_luar|sakit)",
  "start_date": "string (YYYY-MM-DD)",
  "end_date": "string (YYYY-MM-DD)",
  "reason": "string",
  "attachment_path": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengajuan izin berhasil dibuat",
  "data": {
    "user_id": 8,
    "leave_type": "izin",
    "start_date": "2025-08-22T00:00:00.000000Z",
    "end_date": "2025-08-22T00:00:00.000000Z",
    "reason": "Perlu izin untuk keperluan pribadi",
    "attachment_path": null,
    "status": "menunggu",
    "updated_at": "2025-08-21T10:15:36.000000Z",
    "created_at": "2025-08-21T10:15:36.000000Z",
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

### GET /api/leaves/{id}
**Deskripsi:** Mendapatkan detail izin
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengajuan izin berhasil diambil",
  "data": {
    "id": 1,
    "user_id": 1,
    "leave_type": "sakit",
    "start_date": "2025-04-06T00:00:00.000000Z",
    "end_date": "2025-04-06T00:00:00.000000Z",
    "reason": "Demam tinggi, dokter sudah memberi surat.",
    "attachment_path": "leaves/surat_andi.pdf",
    "status": "disetujui",
    "approved_by": 4,
    "approval_comment": null,
    "approved_at": "2025-04-05T10:30:00.000000Z",
    "created_at": "2025-04-05T09:00:00.000000Z",
    "updated_at": "2025-04-05T10:30:00.000000Z"
  }
}
```

**Response Gagal (Izin tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengajuan izin dengan ID tersebut tidak ditemukan"
}
```

### PUT /api/leaves/{id}
**Deskripsi:** Memperbarui izin (misalnya untuk persetujuan)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "status": "string (disetujui|ditolak)",
  "approval_comment": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Status pengajuan izin berhasil diperbarui",
  "data": {
    "id": 3,
    "user_id": 8,
    "leave_type": "izin",
    "start_date": "2025-08-22T00:00:00.000000Z",
    "end_date": "2025-08-22T00:00:00.000000Z",
    "reason": "Perlu izin untuk keperluan pribadi",
    "attachment_path": null,
    "status": "disetujui",
    "approved_by": 8,
    "approval_comment": "Disetujui",
    "approved_at": "2025-08-21T10:20:00.000000Z",
    "created_at": "2025-08-21T10:15:36.000000Z",
    "updated_at": "2025-08-21T10:20:00.000000Z"
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

**Response Gagal (Izin tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengajuan izin dengan ID tersebut tidak ditemukan"
}
```

### DELETE /api/leaves/{id}
**Deskripsi:** Menghapus izin
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengajuan izin berhasil dihapus"
}
```

**Response Gagal (Izin tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengajuan izin dengan ID tersebut tidak ditemukan"
}
```