# Dokumentasi API Manajemen Kelas

## Class Management Endpoints

### GET /api/classes
**Deskripsi:** Mendapatkan semua kelas
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
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00",
      "homeroom_teacher": {
        "id": 2,
        "nisn_nip_nik": "2001",
        "name": "Drs. Eko Wijaya",
        "email": "eko@sekolah.sch.id",
        "phone": "081234567893",
        "role_id": 2,
        "photo_path": "profiles/eko.jpg",
        "is_active": true,
        "created_at": "2025-08-22 10:30:00",
        "updated_at": "2025-08-22 10:30:00"
      }
    }
    // ... data kelas lainnya
  ]
}
```

**Response Gagal (Akses Ditolak):**
```json
{
  "success": false,
  "message": "Hanya admin, kepala sekolah, atau guru yang dapat mengakses data kelas"
}
```

### GET /api/classes/{id}
**Deskripsi:** Mendapatkan kelas berdasarkan ID
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "X IPA 1",
    "homeroom_teacher_id": 2,
    "created_at": "2025-08-22 10:30:00",
    "updated_at": "2025-08-22 10:30:00",
    "homeroom_teacher": {
      "id": 2,
      "nisn_nip_nik": "2001",
      "name": "Drs. Eko Wijaya",
      "email": "eko@sekolah.sch.id",
      "phone": "081234567893",
      "role_id": 2,
      "photo_path": "profiles/eko.jpg",
      "is_active": true,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
    }
  }
}
```

**Response Gagal (Kelas tidak ditemukan):**
```json
{
  "success": false,
  "message": "Kelas dengan ID tersebut tidak ditemukan"
}
```

### POST /api/classes
**Deskripsi:** Membuat kelas baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "name": "string",
  "homeroom_teacher_id": "integer (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Kelas berhasil dibuat",
  "data": {
    "id": 4,
    "name": "XI IPS 1",
    "homeroom_teacher_id": 3,
    "created_at": "2025-08-22 12:00:00",
    "updated_at": "2025-08-22 12:00:00",
    "homeroom_teacher": {
      "id": 3,
      "nisn_nip_nik": "2002",
      "name": "Siti Rahayu, S.Pd",
      "email": "siti@sekolah.sch.id",
      "phone": "081234567894",
      "role_id": 2,
      "photo_path": "profiles/siti.jpg",
      "is_active": true,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
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

### PUT /api/classes/{id}
**Deskripsi:** Memperbarui kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "name": "string (optional)",
  "homeroom_teacher_id": "integer (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Kelas berhasil diperbarui",
  "data": {
    "id": 1,
    "name": "X IPA 1 - Updated",
    "homeroom_teacher_id": 3,
    "created_at": "2025-08-22 10:30:00",
    "updated_at": "2025-08-22 12:05:00",
    "homeroom_teacher": {
      "id": 3,
      "nisn_nip_nik": "2002",
      "name": "Siti Rahayu, S.Pd",
      "email": "siti@sekolah.sch.id",
      "phone": "081234567894",
      "role_id": 2,
      "photo_path": "profiles/siti.jpg",
      "is_active": true,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
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

### DELETE /api/classes/{id}
**Deskripsi:** Menghapus kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Kelas berhasil dihapus"
}
```

**Response Gagal (Kelas tidak ditemukan):**
```json
{
  "success": false,
  "message": "Kelas dengan ID tersebut tidak ditemukan"
}
```

**Response Gagal (Kelas memiliki siswa):**
```json
{
  "success": false,
  "message": "Tidak dapat menghapus kelas yang masih memiliki siswa. Silakan hapus siswa dari kelas terlebih dahulu."
}
```

### GET /api/classes/{id}/students
**Deskripsi:** Mendapatkan semua siswa dalam kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "class": {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
    },
    "students": [
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
        "updated_at": "2025-08-22 10:30:00",
        "student_classes": [
          {
            "id": 1,
            "student_id": 1,
            "class_id": 1,
            "academic_year": 2025,
            "created_at": "2025-08-22 10:30:00"
          }
        ]
      }
      // ... data siswa lainnya
    ]
  }
}
```

### POST /api/classes/{id}/assign-students
**Deskripsi:** Menetapkan siswa ke kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "student_ids": [
    "integer"
  ],
  "academic_year": "integer"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "2 siswa berhasil ditetapkan ke kelas",
  "data": {
    "class": {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00",
      "homeroom_teacher": {
        "id": 2,
        "nisn_nip_nik": "2001",
        "name": "Drs. Eko Wijaya",
        "email": "eko@sekolah.sch.id",
        "phone": "081234567893",
        "role_id": 2,
        "photo_path": "profiles/eko.jpg",
        "is_active": true,
        "created_at": "2025-08-22 10:30:00",
        "updated_at": "2025-08-22 10:30:00"
      }
    },
    "assigned_students": [
      {
        "id": 4,
        "student_id": 4,
        "class_id": 1,
        "academic_year": 2025,
        "created_at": "2025-08-22 12:10:00"
      },
      {
        "id": 5,
        "student_id": 5,
        "class_id": 1,
        "academic_year": 2025,
        "created_at": "2025-08-22 12:10:00"
      }
    ]
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

### POST /api/classes/{id}/remove-students
**Deskripsi:** Menghapus siswa dari kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "student_ids": [
    "integer"
  ],
  "academic_year": "integer"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "2 siswa berhasil dihapus dari kelas",
  "data": {
    "class": {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
    },
    "removed_count": 2
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