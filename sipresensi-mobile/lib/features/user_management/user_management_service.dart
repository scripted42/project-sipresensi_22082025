import 'dart:convert';
import 'package:sipresensi_mobile/core/network/api_client.dart';
import 'package:sipresensi_mobile/core/models/user.dart';

class UserManagementService {
  static const String usersUrl = '${ApiClient.baseUrl}/users';

  Future<List<User>?> getUsers() async {
    try {
      final response = await ApiClient.get(usersUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((userData) => User.fromJson(userData))
              .toList();
        }
      }
      return null;
    } catch (e) {
      print('Get users error: $e');
      return null;
    }
  }

  Future<User?> createUser({
    required String nisnNipNik,
    required String name,
    required String email,
    required int roleId,
    required String phone,
  }) async {
    try {
      final response = await ApiClient.post(usersUrl, body: {
        'nisn_nip_nik': nisnNipNik,
        'name': name,
        'email': email,
        'role_id': roleId,
        'phone': phone,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Create user error: $e');
      return null;
    }
  }

  Future<User?> updateUser({
    required int id,
    required String nisnNipNik,
    required String name,
    required String email,
    required int roleId,
    required String phone,
  }) async {
    try {
      final response = await ApiClient.put('$usersUrl/$id', body: {
        'nisn_nip_nik': nisnNipNik,
        'name': name,
        'email': email,
        'role_id': roleId,
        'phone': phone,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Update user error: $e');
      return null;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final response = await ApiClient.delete('$usersUrl/$id');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Delete user error: $e');
      return false;
    }
  }
}