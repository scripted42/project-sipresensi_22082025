# Dokumentasi API SiPresensi - Endpoint yang Telah Diuji

## 1. Auth Endpoints

### POST /api/auth/login
**Deskripsi:** Login pengguna ke sistem
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
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "email": "andi@siswa.sch.id",
      "phone": "081234567890",
      "role_id": 1,
      "photo_path": "profiles/andi.jpg",
      "is_active": 1,
      "created_at": "2025-08-20T23:30:07.000000Z",
      "updated_at": "2025-08-20T23:30:07.000000Z"
    },
    "token": "1|umK7zuVmRiDQV7DoWvoB4bwmyPWV7v05MJE2H4lm2cd7c5e1"
  }
}
```

**Response Gagal:**
```json
{
  "success": false,
  "message": "Kredensial tidak valid"
}
```

### POST /api/auth/logout
**Deskripsi:** Logout pengguna dari sistem
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

## 2. User Endpoints

### GET /api/user
**Deskripsi:** Mendapatkan data pengguna yang sedang login
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
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "email": "andi@siswa.sch.id",
      "phone": "081234567890",
      "role_id": 1,
      "photo_path": "profiles/andi.jpg",
      "is_active": 1,
      "created_at": "2025-08-20T23:30:07.000000Z",
      "updated_at": "2025-08-20T23:30:07.000000Z"
    }
  }
}
```

## Catatan Penting:
1. Semua endpoint auth (kecuali login) memerlukan token autentikasi di header Authorization
2. Token didapatkan setelah login berhasil dan harus disimpan untuk digunakan dalam request selanjutnya
3. Setelah logout, token tidak lagi valid dan pengguna harus login ulang untuk mendapatkan token baru