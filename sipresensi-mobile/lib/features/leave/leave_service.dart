import 'dart:convert';
import 'package:sipresensi_mobile/core/network/api_client.dart';
import 'package:sipresensi_mobile/core/models/leave.dart';

class LeaveService {
  static const String leavesUrl = ApiClient.leavesUrl;

  Future<List<Leave>?> getLeaves() async {
    try {
      final response = await ApiClient.get(leavesUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((leaveData) => Leave.fromJson(leaveData))
              .toList();
        }
      }
      return null;
    } catch (e) {
      print('Get leaves error: $e');
      return null;
    }
  }

  Future<Leave?> submitLeave({
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    String? attachmentPath,
  }) async {
    try {
      final response = await ApiClient.post(leavesUrl, body: {
        'leave_type': leaveType,
        'start_date': startDate,
        'end_date': endDate,
        'reason': reason,
        if (attachmentPath != null) 'attachment_path': attachmentPath,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return Leave.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Submit leave error: $e');
      return null;
    }
  }
}