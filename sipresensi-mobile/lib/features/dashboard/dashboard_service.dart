import 'dart:convert';
import 'package:sipresensi_mobile/core/network/api_client.dart';
import 'package:sipresensi_mobile/core/models/dashboard.dart';

class DashboardService {
  static const String dashboardUrl = ApiClient.dashboardUrl;
  static const String classesUrl = ApiClient.classesUrl;

  Future<DashboardData?> getDashboardData() async {
    try {
      final response = await ApiClient.get(dashboardUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return DashboardData.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print('Get dashboard data error: $e');
      return null;
    }
  }

  Future<List<Class>?> getClasses() async {
    try {
      final response = await ApiClient.get(classesUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((classData) => Class.fromJson(classData))
              .toList();
        }
      }
      return null;
    } catch (e) {
      print('Get classes error: $e');
      return null;
    }
  }
}