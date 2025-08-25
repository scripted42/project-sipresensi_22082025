import 'user.dart';

class DashboardData {
  final User user;
  final List<Class>? classes;
  final AttendanceStatistics? attendanceStatistics;
  final List<Leave>? recentLeaves;
  final List<Announcement>? recentAnnouncements;

  DashboardData({
    required this.user,
    this.classes,
    this.attendanceStatistics,
    this.recentLeaves,
    this.recentAnnouncements,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      user: User.fromJson(json['data']['user'] as Map<String, dynamic>),
      classes: json['data']['classes'] != null
          ? (json['data']['classes'] as List)
              .map((classData) => Class.fromJson(classData as Map<String, dynamic>))
              .toList()
          : null,
      attendanceStatistics: json['data']['attendance_statistics'] != null
          ? AttendanceStatistics.fromJson(json['data']['attendance_statistics'] as Map<String, dynamic>)
          : null,
      recentLeaves: json['data']['recent_leaves'] != null
          ? (json['data']['recent_leaves'] as List)
              .map((leaveData) => Leave.fromJson(leaveData as Map<String, dynamic>))
              .toList()
          : null,
      recentAnnouncements: json['data']['recent_announcements'] != null
          ? (json['data']['recent_announcements'] as List)
              .map((announcementData) => Announcement.fromJson(announcementData as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class Class {
  final int id;
  final String name;
  final int? homeroomTeacherId;

  Class({
    required this.id,
    required this.name,
    this.homeroomTeacherId,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      homeroomTeacherId: json['homeroom_teacher_id'] as int?,
    );
  }
}

class AttendanceStatistics {
  final int totalStudents;
  final int present;
  final int late;
  final int absent;

  AttendanceStatistics({
    required this.totalStudents,
    required this.present,
    required this.late,
    required this.absent,
  });

  factory AttendanceStatistics.fromJson(Map<String, dynamic> json) {
    return AttendanceStatistics(
      totalStudents: json['total_students'] as int? ?? 0,
      present: json['present'] as int? ?? 0,
      late: json['late'] as int? ?? 0,
      absent: json['absent'] as int? ?? 0,
    );
  }
}

class Leave {
  final int id;
  final int userId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String? attachmentPath;
  final String status;
  final int? approvedBy;
  final String? approvalComment;
  final String? approvedAt;
  final String createdAt;
  final String updatedAt;

  Leave({
    required this.id,
    required this.userId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.attachmentPath,
    required this.status,
    this.approvedBy,
    this.approvalComment,
    this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      leaveType: json['leave_type'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      attachmentPath: json['attachment_path'] as String?,
      status: json['status'] as String? ?? '',
      approvedBy: json['approved_by'] as int?,
      approvalComment: json['approval_comment'] as String?,
      approvedAt: json['approved_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
  
  // Get leave type name in Indonesian
  String getLeaveTypeName() {
    switch (leaveType) {
      case 'izin':
        return 'Izin';
      case 'cuti':
        return 'Cuti';
      case 'dinas_luar':
        return 'Dinas Luar';
      case 'sakit':
        return 'Sakit';
      default:
        return leaveType;
    }
  }
  
  // Get status name in Indonesian
  String getStatusName() {
    switch (status) {
      case 'menunggu':
        return 'Menunggu';
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      default:
        return status;
    }
  }
}

class Announcement {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final bool isPublished;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.isPublished,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      authorId: json['author_id'] as int? ?? 0,
      isPublished: json['is_published'] as bool? ?? false,
      publishedAt: json['published_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}