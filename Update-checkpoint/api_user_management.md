# Dokumentasi API Manajemen Pengguna

## User Management Endpoints

### GET /api/users
**Deskripsi:** Mendapatkan daftar pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `role_id`: Filter berdasarkan role
- `is_active`: Filter berdasarkan status aktif (1/0)
- `per_page`: Jumlah data per halaman (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengguna berhasil diambil",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "nisn_nip_nik": "1001",
        "name": "Andi Pratama",
        "email": "andi@siswa.sch.id",
        "phone": "081234567890",
        "role_id": 1,
        "photo_path": "profiles/andi.jpg",
        "is_active": true,
        "created_at": "2025-08-22 10:30:00",
        "updated_at": "2025-08-22 10:30:00"
      }
      // ... data pengguna lainnya
    ],
    "first_page_url": "http://127.0.0.1:8000/api/users?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/users?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/users",
    "per_page": 15,
    "prev_page_url": null,
    "to": 2,
    "total": 2
  }
}
```

**Response Gagal (Akses Ditolak):**
```json
{
  "success": false,
  "message": "Hanya admin yang dapat mengakses data pengguna"
}
```

### POST /api/users
**Deskripsi:** Menambah pengguna baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "string",
  "name": "string",
  "email": "string|email (optional)",
  "phone": "string (optional)",
  "password": "string",
  "role_id": "integer",
  "photo_path": "string (optional)",
  "is_active": "boolean (optional, default: true)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengguna berhasil ditambahkan",
  "data": {
    "nisn_nip_nik": "1005",
    "name": "Eka Putri",
    "email": "eka@siswa.sch.id",
    "phone": "081234567899",
    "role_id": 1,
    "photo_path": "profiles/eka.jpg",
    "is_active": true,
    "updated_at": "2025-08-22 12:30:00",
    "created_at": "2025-08-22 12:30:00",
    "id": 10
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

### GET /api/users/{id}
**Deskripsi:** Mendapatkan detail pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengguna berhasil diambil",
  "data": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama",
    "email": "andi@siswa.sch.id",
    "phone": "081234567890",
    "role_id": 1,
    "photo_path": "profiles/andi.jpg",
    "is_active": true,
    "created_at": "2025-08-22 10:30:00",
    "updated_at": "2025-08-22 10:30:00"
  }
}
```

**Response Gagal (Pengguna tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengguna dengan ID tersebut tidak ditemukan"
}
```

### PUT /api/users/{id}
**Deskripsi:** Memperbarui pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "string (optional)",
  "name": "string (optional)",
  "email": "string|email (optional)",
  "phone": "string (optional)",
  "password": "string (optional)",
  "role_id": "integer (optional)",
  "photo_path": "string (optional)",
  "is_active": "boolean (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengguna berhasil diperbarui",
  "data": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama - Updated",
    "email": "andi.updated@siswa.sch.id",
    "phone": "081234567800",
    "role_id": 1,
    "photo_path": "profiles/andi.jpg",
    "is_active": true,
    "created_at": "2025-08-22 10:30:00",
    "updated_at": "2025-08-22 12:35:00"
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

**Response Gagal (Pengguna tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengguna dengan ID tersebut tidak ditemukan"
}
```

### DELETE /api/users/{id}
**Deskripsi:** Menghapus pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengguna berhasil dihapus"
}
```

**Response Gagal (Pengguna tidak ditemukan):**
```json
{
  "success": false,
  "message": "Pengguna dengan ID tersebut tidak ditemukan"
}
```

**Response Gagal (Tidak dapat menghapus diri sendiri):**
```json
{
  "success": false,
  "message": "Anda tidak dapat menghapus akun Anda sendiri"
}
```