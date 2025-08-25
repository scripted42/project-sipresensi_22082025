import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipresensi_mobile/core/network/api_client.dart';
import 'package:sipresensi_mobile/core/models/user.dart';

class AuthService {
  static const String loginUrl = ApiClient.loginUrl;
  static const String logoutUrl = ApiClient.logoutUrl;
  static const String profileUrl = ApiClient.userProfileUrl;

  Future<Map<String, dynamic>?> login(String nisnNipNik, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nisn_nip_nik': nisnNipNik,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Save token to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['data']['token']);
          
          // Save user data
          final userJson = data['data']['user'];
          await prefs.setString('user', jsonEncode(userJson));
          
          return data;
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await ApiClient.post(logoutUrl);
      
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('user');
        return true;
      }
      return false;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<User?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');
      
      if (userString != null) {
        final userJson = jsonDecode(userString);
        return User.fromJson(userJson);
      }
      
      final response = await ApiClient.get(profileUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final user = User.fromJson(data['data']);
          
          // Save to shared preferences
          await prefs.setString('user', jsonEncode(data['data']));
          
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }
}