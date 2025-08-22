# Dokumentasi API User & Profil

## User & Profile Endpoints

### GET /api/user
**Deskripsi:** Mendapatkan data user yang sedang login
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
      "id": 8,
      "nisn_nip_nik": "5001",
      "name": "Admin Utama",
      "email": "admin@sekolah.sch.id",
      "phone": "081234567897",
      "role_id": 5,
      "photo_path": "profiles/admin.jpg",
      "is_active": true,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    }
  }
}
```

### GET /api/profile
**Deskripsi:** Mendapatkan profil user
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data profil berhasil diambil",
  "data": {
    "id": 8,
    "nisn_nip_nik": "5001",
    "name": "Admin Utama",
    "email": "admin@sekolah.sch.id",
    "phone": "081234567897",
    "role_id": 5,
    "photo_path": "profiles/admin.jpg",
    "is_active": true,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-21T08:54:57.000000Z"
  }
}
```

### PUT /api/profile
**Deskripsi:** Memperbarui profil
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "name": "string (optional)",
  "email": "string|email (optional)",
  "phone": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Profil berhasil diperbarui",
  "data": {
    "id": 8,
    "nisn_nip_nik": "5001",
    "name": "Admin Utama - Updated",
    "email": "admin.updated@sekolah.sch.id",
    "phone": "081234567898",
    "role_id": 5,
    "photo_path": "profiles/admin.jpg",
    "is_active": true,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-22T15:00:00.000000Z"
  }
}
```

### PUT /api/profile/password
**Deskripsi:** Mengganti password
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "current_password": "string",
  "new_password": "string",
  "new_password_confirmation": "string"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Password berhasil diubah"
}
```

**Response Gagal (Password saat ini salah):**
```json
{
  "success": false,
  "message": "Password saat ini salah"
}
```