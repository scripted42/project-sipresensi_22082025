import 'dart:convert';
import 'package:sipresensi_mobile/core/network/api_client.dart';
import 'package:sipresensi_mobile/core/models/announcement.dart';

class AnnouncementService {
  static const String announcementsUrl = ApiClient.announcementsUrl;

  Future<List<Announcement>?> getAnnouncements() async {
    try {
      final response = await ApiClient.get(announcementsUrl);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((announcementData) => Announcement.fromJson(announcementData))
              .toList();
        }
      }
      return null;
    } catch (e) {
      print('Get announcements error: $e');
      return null;
    }
  }

  Future<Announcement?> createAnnouncement({
    required String title,
    required String content,
  }) async {
    try {
      final response = await ApiClient.post(announcementsUrl, body: {
        'title': title,
        'content': content,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return Announcement.fromJson(data['data']);
        } else {
          print('Create announcement API error: ${data['message']}');
        }
      } else {
        print('Create announcement HTTP error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      return null;
    } catch (e) {
      print('Create announcement error: $e');
      return null;
    }
  }

  Future<Announcement?> updateAnnouncement({
    required int id,
    required String title,
    required String content,
  }) async {
    try {
      final response = await ApiClient.put('$announcementsUrl/$id', body: {
        'title': title,
        'content': content,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return Announcement.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Update announcement error: $e');
      return null;
    }
  }

  Future<bool> deleteAnnouncement(int id) async {
    try {
      final response = await ApiClient.delete('$announcementsUrl/$id');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Delete announcement error: $e');
      return false;
    }
  }
}