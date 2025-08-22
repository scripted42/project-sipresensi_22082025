# Dokumentasi API Autentikasi

## Auth Endpoints

### POST /api/auth/login
**Deskripsi:** Login dengan `nisn_nip_nik` dan `password`
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
    },
    "token": "18|GYwljnaQN5wdl11RpKDgO08YWJMRSFAxIDsH8bpV66f2ef83"
  }
}
```

**Response Gagal (Kredensial tidak valid):**
```json
{
  "success": false,
  "message": "Kredensial tidak valid"
}
```

### POST /api/auth/logout
**Deskripsi:** Logout (jika menggunakan token berbasis sesi)
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

**Response Gagal (Token tidak valid):**
```json
{
  "success": false,
  "message": "Token tidak valid"
}
```