import 'dart:convert';
import 'package:sipresensi_mobile/core/network/api_client.dart';
import 'package:sipresensi_mobile/core/models/attendance.dart';

class StudentAttendanceService {
  static const String scanQrUrl = ApiClient.studentAttendanceScanUrl;
  static const String bulkAttendanceUrl = ApiClient.studentAttendanceBulkUrl;
  static const String classStatusUrl = ApiClient.studentAttendanceClassStatusUrl;

  Future<StudentAttendanceResponse?> scanStudentQR({
    String? qrCode,
    String? nisnNipNik,
    required int classId,
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    try {
      final response = await ApiClient.post(scanQrUrl, body: {
        if (qrCode != null) 'qr_code': qrCode,
        if (nisnNipNik != null) 'nisn_nip_nik': nisnNipNik,
        'class_id': classId,
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StudentAttendanceResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Scan student QR error: $e');
      return null;
    }
  }

  Future<BulkAttendanceResponse?> submitBulkAttendance({
    required int classId,
    String? date,
  }) async {
    try {
      final response = await ApiClient.post(bulkAttendanceUrl, body: {
        'class_id': classId,
        if (date != null) 'date': date,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BulkAttendanceResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Bulk attendance error: $e');
      return null;
    }
  }

  Future<ClassAttendanceStatus?> getClassAttendanceStatus({
    required int classId,
    String? date,
  }) async {
    try {
      final url = date != null
          ? '$classStatusUrl/$classId?date=$date'
          : '$classStatusUrl/$classId';
          
      final response = await ApiClient.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return ClassAttendanceStatus.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Get class attendance status error: $e');
      return null;
    }
  }
}