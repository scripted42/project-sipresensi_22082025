import 'dart:convert';
import 'package:sipresensi_mobile/core/network/api_client.dart';
import 'package:sipresensi_mobile/core/models/attendance.dart';

class EmployeeAttendanceService {
  static const String qrCodeDynamicUrl = ApiClient.qrCodeDynamicUrl;
  static const String qrCodeVerifyUrl = ApiClient.qrCodeVerifyUrl;
  static const String attendanceCheckinUrl = ApiClient.attendanceCheckinUrl;
  static const String attendanceCheckoutUrl = ApiClient.attendanceCheckoutUrl;
  static const String attendanceHistoryUrl = ApiClient.attendanceHistoryUrl;

  Future<DynamicQRToken?> getDynamicQRToken() async {
    try {
      final response = await ApiClient.get(qrCodeDynamicUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return DynamicQRToken.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Get dynamic QR token error: $e');
      return null;
    }
  }

  Future<QRVerificationResponse?> verifyQRToken({
    required int userId,
    required String type,
    required String qrToken,
    required double latitude,
    required double longitude,
    required int accuracy,
    required String photo, // Base64 encoded photo
  }) async {
    try {
      final response = await ApiClient.post(qrCodeVerifyUrl, body: {
        'user_id': userId,
        'type': type,
        'qr_token': qrToken,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'photo': photo,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QRVerificationResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Verify QR token error: $e');
      return null;
    }
  }

  Future<QRVerificationResponse?> submitCheckin({
    required String qrToken,
    required double latitude,
    required double longitude,
    required int accuracy,
    required String photo, // Base64 encoded photo
  }) async {
    try {
      final response = await ApiClient.post(attendanceCheckinUrl, body: {
        'qr_token': qrToken,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'photo': photo,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QRVerificationResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Submit checkin error: $e');
      return null;
    }
  }

  Future<QRVerificationResponse?> submitCheckout({
    required String qrToken,
    required double latitude,
    required double longitude,
    required int accuracy,
    required String photo, // Base64 encoded photo
  }) async {
    try {
      final response = await ApiClient.post(attendanceCheckoutUrl, body: {
        'qr_token': qrToken,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'photo': photo,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QRVerificationResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Submit checkout error: $e');
      return null;
    }
  }

  Future<AttendanceHistoryResponse?> getAttendanceHistory() async {
    try {
      final response = await ApiClient.get(attendanceHistoryUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return AttendanceHistoryResponse.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print('Get attendance history error: $e');
      return null;
    }
  }
}