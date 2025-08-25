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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'attachment_path': attachmentPath,
      'status': status,
      'approved_by': approvedBy,
      'approval_comment': approvalComment,
      'approved_at': approvedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
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