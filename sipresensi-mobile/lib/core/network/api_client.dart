import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator localhost
  static const String loginUrl = '$baseUrl/auth/login';
  static const String logoutUrl = '$baseUrl/auth/logout';
  static const String userProfileUrl = '$baseUrl/profile';
  static const String dashboardUrl = '$baseUrl/dashboard';
  static const String classesUrl = '$baseUrl/classes';
  static const String studentAttendanceScanUrl = '$baseUrl/student-attendance/scan-qr';
  static const String studentAttendanceBulkUrl = '$baseUrl/student-attendance/bulk';
  static const String studentAttendanceClassStatusUrl = '$baseUrl/student-attendance/class-status';
  static const String qrCodeDynamicUrl = '$baseUrl/qrcode/dynamic';
  static const String qrCodeVerifyUrl = '$baseUrl/qrcode/verify';
  static const String attendanceCheckinUrl = '$baseUrl/attendance/checkin';
  static const String attendanceCheckoutUrl = '$baseUrl/attendance/checkout';
  static const String attendanceHistoryUrl = '$baseUrl/attendance/history';
  static const String leavesUrl = '$baseUrl/leaves';
  static const String announcementsUrl = '$baseUrl/announcements';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  static Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> get(String url) async {
    final headers = await _getHeaders();
    return http.get(
      Uri.parse(url),
      headers: headers,
    );
  }

  static Future<http.Response> put(String url, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    return http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String url) async {
    final headers = await _getHeaders();
    return http.delete(
      Uri.parse(url),
      headers: headers,
    );
  }
}