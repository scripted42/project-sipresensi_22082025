class StudentAttendanceResponse {
  final bool success;
  final Student? student;
  final String message;

  StudentAttendanceResponse({
    required this.success,
    this.student,
    required this.message,
  });

  factory StudentAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceResponse(
      success: json['success'] as bool? ?? false,
      student: json['student'] != null ? Student.fromJson(json['student'] as Map<String, dynamic>) : null,
      message: json['message'] as String? ?? '',
    );
  }
}

class Student {
  final int id;
  final String nisnNipNik;
  final String name;

  Student({
    required this.id,
    required this.nisnNipNik,
    required this.name,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int? ?? 0,
      nisnNipNik: json['nisn_nip_nik'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class BulkAttendanceResponse {
  final bool success;
  final String message;
  final BulkAttendanceData data;

  BulkAttendanceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BulkAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return BulkAttendanceResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: BulkAttendanceData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class BulkAttendanceData {
  final int classId;
  final String date;
  final int totalStudents;
  final int alreadyAttended;
  final int newlyAttended;
  final List<ProcessedStudent> processedStudents;

  BulkAttendanceData({
    required this.classId,
    required this.date,
    required this.totalStudents,
    required this.alreadyAttended,
    required this.newlyAttended,
    required this.processedStudents,
  });

  factory BulkAttendanceData.fromJson(Map<String, dynamic> json) {
    return BulkAttendanceData(
      classId: json['class_id'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      totalStudents: json['total_students'] as int? ?? 0,
      alreadyAttended: json['already_attended'] as int? ?? 0,
      newlyAttended: json['newly_attended'] as int? ?? 0,
      processedStudents: (json['processed_students'] as List?)
          ?.map((studentData) => ProcessedStudent.fromJson(studentData as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class ProcessedStudent {
  final int id;
  final String nisnNipNik;
  final String name;
  final bool attended;

  ProcessedStudent({
    required this.id,
    required this.nisnNipNik,
    required this.name,
    required this.attended,
  });

  factory ProcessedStudent.fromJson(Map<String, dynamic> json) {
    return ProcessedStudent(
      id: json['id'] as int? ?? 0,
      nisnNipNik: json['nisn_nip_nik'] as String? ?? '',
      name: json['name'] as String? ?? '',
      attended: json['attended'] as bool? ?? false,
    );
  }
}

class ClassAttendanceStatus {
  final List<StudentAttendanceStatus> students;

  ClassAttendanceStatus({
    required this.students,
  });

  factory ClassAttendanceStatus.fromJson(List<dynamic> json) {
    return ClassAttendanceStatus(
      students: json
          .map((studentData) => StudentAttendanceStatus.fromJson(studentData as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StudentAttendanceStatus {
  final int id;
  final String nisnNipNik;
  final String name;
  final bool attended;

  StudentAttendanceStatus({
    required this.id,
    required this.nisnNipNik,
    required this.name,
    required this.attended,
  });

  factory StudentAttendanceStatus.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceStatus(
      id: json['id'] as int? ?? 0,
      nisnNipNik: json['nisn_nip_nik'] as String? ?? '',
      name: json['name'] as String? ?? '',
      attended: json['attended'] as bool? ?? false,
    );
  }
}

// Employee attendance models
class DynamicQRToken {
  final int id;
  final String token;
  final String createdAt;
  final String expiresAt;
  final bool used;
  final int? usedBy;

  DynamicQRToken({
    required this.id,
    required this.token,
    required this.createdAt,
    required this.expiresAt,
    required this.used,
    this.usedBy,
  });

  factory DynamicQRToken.fromJson(Map<String, dynamic> json) {
    return DynamicQRToken(
      id: json['id'] as int? ?? 0,
      token: json['token'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      expiresAt: json['expires_at'] as String? ?? '',
      used: json['used'] as bool? ?? false,
      usedBy: json['used_by'] as int?,
    );
  }
}

class QRVerificationResponse {
  final bool success;
  final String message;
  final QRVerificationData? data;

  QRVerificationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QRVerificationResponse.fromJson(Map<String, dynamic> json) {
    return QRVerificationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? QRVerificationData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}

class QRVerificationData {
  final int userId;
  final String type;
  final String latitude;
  final String longitude;
  final int accuracy;
  final String photoPath;
  final String qrTokenUsed;
  final String timestamp;
  final int id;

  QRVerificationData({
    required this.userId,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.photoPath,
    required this.qrTokenUsed,
    required this.timestamp,
    required this.id,
  });

  factory QRVerificationData.fromJson(Map<String, dynamic> json) {
    return QRVerificationData(
      userId: json['user_id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      longitude: json['longitude'] as String? ?? '',
      accuracy: json['accuracy'] as int? ?? 0,
      photoPath: json['photo_path'] as String? ?? '',
      qrTokenUsed: json['qr_token_used'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }
}

class AttendanceHistoryResponse {
  final bool success;
  final String message;
  final List<AttendanceRecord> data;

  AttendanceHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List?)
          ?.map((recordData) => AttendanceRecord.fromJson(recordData as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class AttendanceRecord {
  final int id;
  final int userId;
  final String type;
  final String latitude;
  final String longitude;
  final int accuracy;
  final String photoPath;
  final String qrTokenUsed;
  final String status;
  final String timestamp;
  final String dateOnly;
  final bool synced;
  final String createdAt;

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.photoPath,
    required this.qrTokenUsed,
    required this.status,
    required this.timestamp,
    required this.dateOnly,
    required this.synced,
    required this.createdAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      longitude: json['longitude'] as String? ?? '',
      accuracy: json['accuracy'] as int? ?? 0,
      photoPath: json['photo_path'] as String? ?? '',
      qrTokenUsed: json['qr_token_used'] as String? ?? '',
      status: json['status'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      dateOnly: json['date_only'] as String? ?? '',
      synced: json['synced'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
  
  // Get type name in Indonesian
  String getTypeName() {
    switch (type) {
      case 'checkin':
        return 'Masuk';
      case 'checkout':
        return 'Keluar';
      default:
        return type;
    }
  }
  
  // Get status name in Indonesian
  String getStatusName() {
    switch (status) {
      case 'hadir':
        return 'Hadir';
      case 'terlambat':
        return 'Terlambat';
      default:
        return status;
    }
  }
}