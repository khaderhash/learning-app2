import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/storage_service.dart';
import '../../utils/helpers.dart';
import '../models/notification_model.dart';

class NotificationProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<NotificationModel>> getNotifications() async {
    final url = Uri.parse('$baseUrl/notifications');
    try {
      print("Fetching notifications...");
      final response = await http.get(url, headers: await _getHeaders());
      print("Notifications Response Status: ${response.statusCode}");
      print("Notifications Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          final Map<String, dynamic> paginationObject = responseData['data'];
          if (paginationObject.containsKey('data') &&
              paginationObject['data'] is List) {
            final List<dynamic> notificationsJson = paginationObject['data'];

            if (notificationsJson.isEmpty) {
              print("No notifications found in the response list.");
              return [];
            }

            print(
              "Found ${notificationsJson.length} notifications. Parsing...",
            );
            return notificationsJson
                .map((json) => NotificationModel.fromJson(json))
                .toList();
          }
        }
        throw Exception("Unexpected JSON structure for notifications.");
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print("Error in getNotifications: $e");
      rethrow;
    }
  }

  Future<int> getUnreadCount() async {
    final url = Uri.parse('$baseUrl/notifications/unread-count');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['unread_count'];
    } else {
      throw Exception('Failed to get unread count');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final url = Uri.parse('$baseUrl/notifications/$notificationId/read');
    final response = await http.put(url, headers: await _getHeaders());
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> markAllAsRead() async {
    final url = Uri.parse('$baseUrl/notifications/read-all');
    final response = await http.put(url, headers: await _getHeaders());
    if (response.statusCode != 200) {
      throw Exception('Failed to mark all as read');
    }
  }
}
