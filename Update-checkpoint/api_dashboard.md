# Dokumentasi API Dashboard

## Dashboard Endpoints

### GET /api/dashboard
**Deskripsi:** Mendapatkan data dashboard berdasarkan peran pengguna yang sedang login
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

## Response Berdasarkan Peran

### Dashboard Siswa
**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
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
    },
    "attendance_status": "hadir",
    "recent_leaves": [
      {
        "id": 1,
        "user_id": 1,
        "leave_type": "sakit",
        "start_date": "2025-04-06",
        "end_date": "2025-04-06",
        "reason": "Demam tinggi, dokter sudah memberi surat.",
        "attachment_path": "leaves/surat_andi.pdf",
        "status": "disetujui",
        "approved_by": 4,
        "approval_comment": null,
        "approved_at": "2025-04-05 10:30:00",
        "created_at": "2025-04-05 09:00:00",
        "updated_at": "2025-04-05 10:30:00"
      }
    ],
    "recent_announcements": [
      {
        "id": 1,
        "title": "Jadwal Ujian Tengah Semester",
        "content": "UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.",
        "author_id": 4,
        "is_published": true,
        "published_at": "2025-04-01 08:00:00",
        "created_at": "2025-04-01 08:00:00",
        "updated_at": "2025-04-01 08:00:00"
      }
    ]
  }
}
```

### Dashboard Guru
**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
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
    },
    "classes": [
      {
        "id": 1,
        "name": "X IPA 1",
        "homeroom_teacher_id": 2,
        "created_at": "2025-08-22 10:30:00",
        "updated_at": "2025-08-22 10:30:00"
      }
    ],
    "attendance_statistics": {
      "total_students": 2,
      "present": 1,
      "late": 0,
      "absent": 1
    },
    "recent_leaves": [
      {
        "id": 2,
        "user_id": 2,
        "leave_type": "izin",
        "start_date": "2025-04-07",
        "end_date": "2025-04-07",
        "reason": "Acara keluarga.",
        "attachment_path": null,
        "status": "menunggu",
        "approved_by": null,
        "approval_comment": null,
        "approved_at": null,
        "created_at": "2025-04-06 14:00:00",
        "updated_at": "2025-04-06 14:00:00"
      }
    ],
    "recent_announcements": [
      {
        "id": 2,
        "title": "Libur Hari Raya",
        "content": "Sekolah libur mulai 1 Mei 2025 hingga 5 Mei 2025.",
        "author_id": 5,
        "is_published": true,
        "published_at": "2025-04-02 08:00:00",
        "created_at": "2025-04-02 08:00:00",
        "updated_at": "2025-04-02 08:00:00"
      }
    ]
  }
}
```

### Dashboard Pegawai
**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 3,
      "nisn_nip_nik": "3001",
      "name": "Agus Setiawan",
      "email": "agus@sekolah.sch.id",
      "phone": "081234567895",
      "role_id": 3,
      "photo_path": "profiles/agus.jpg",
      "is_active": true,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
    },
    "attendance_status": "belum_absen",
    "recent_leaves": [],
    "recent_announcements": [
      {
        "id": 1,
        "title": "Jadwal Ujian Tengah Semester",
        "content": "UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.",
        "author_id": 4,
        "is_published": true,
        "published_at": "2025-04-01 08:00:00",
        "created_at": "2025-04-01 08:00:00",
        "updated_at": "2025-04-01 08:00:00"
      }
    ]
  }
}
```

### Dashboard Kepala Sekolah
**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 4,
      "nisn_nip_nik": "4001",
      "name": "Dr. Haryanto, M.Pd",
      "email": "haryanto@sekolah.sch.id",
      "phone": "081234567896",
      "role_id": 4,
      "photo_path": "profiles/haryanto.jpg",
      "is_active": true,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
    },
    "user_statistics": {
      "total_students": 3,
      "total_teachers": 2,
      "total_staff": 1
    },
    "attendance_statistics": {
      "students": {
        "present": 1,
        "late": 0,
        "total": 3
      },
      "teachers": {
        "present": 1,
        "late": 0,
        "total": 2
      }
    },
    "pending_leaves": [
      {
        "id": 2,
        "user_id": 2,
        "leave_type": "izin",
        "start_date": "2025-04-07",
        "end_date": "2025-04-07",
        "reason": "Acara keluarga.",
        "attachment_path": null,
        "status": "menunggu",
        "approved_by": null,
        "approval_comment": null,
        "approved_at": null,
        "created_at": "2025-04-06 14:00:00",
        "updated_at": "2025-04-06 14:00:00"
      }
    ],
    "recent_announcements": [
      {
        "id": 2,
        "title": "Libur Hari Raya",
        "content": "Sekolah libur mulai 1 Mei 2025 hingga 5 Mei 2025.",
        "author_id": 5,
        "is_published": true,
        "published_at": "2025-04-02 08:00:00",
        "created_at": "2025-04-02 08:00:00",
        "updated_at": "2025-04-02 08:00:00"
      }
    ]
  }
}
```

### Dashboard Admin
**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 5,
      "nisn_nip_nik": "5001",
      "name": "Admin Utama",
      "email": "admin@sekolah.sch.id",
      "phone": "081234567897",
      "role_id": 5,
      "photo_path": "profiles/admin.jpg",
      "is_active": true,
      "created_at": "2025-08-22 10:30:00",
      "updated_at": "2025-08-22 10:30:00"
    },
    "system_statistics": {
      "total_users": 9,
      "total_students": 3,
      "total_teachers": 2,
      "total_staff": 1,
      "total_classes": 3
    },
    "attendance_statistics": {
      "present_students": 1,
      "present_teachers": 1
    },
    "pending_leaves": [
      {
        "id": 2,
        "user_id": 2,
        "leave_type": "izin",
        "start_date": "2025-04-07",
        "end_date": "2025-04-07",
        "reason": "Acara keluarga.",
        "attachment_path": null,
        "status": "menunggu",
        "approved_by": null,
        "approval_comment": null,
        "approved_at": null,
        "created_at": "2025-04-06 14:00:00",
        "updated_at": "2025-04-06 14:00:00"
      }
    ],
    "recent_announcements": [
      {
        "id": 2,
        "title": "Libur Hari Raya",
        "content": "Sekolah libur mulai 1 Mei 2025 hingga 5 Mei 2025.",
        "author_id": 5,
        "is_published": true,
        "published_at": "2025-04-02 08:00:00",
        "created_at": "2025-04-02 08:00:00",
        "updated_at": "2025-04-02 08:00:00"
      }
    ]
  }
}
```