import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../utils/helpers.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Conversation>> getMyConversations() async {
    final url = Uri.parse('$baseUrl/get/my/coversation');

    try {
      print("Fetching conversations from: $url");
      final response = await http.get(url, headers: await _getHeaders());
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);

        if (decodedBody is! List) {
          print("Error: Response body is not a List.");
          throw Exception('Unexpected response format from server.');
        }

        final List<dynamic> data = decodedBody;
        if (data.isEmpty) {
          print("Conversations list is empty.");
          return [];
        }

        print("Successfully decoded conversations list. Count: ${data.length}");
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        print("Error: Received status code ${response.statusCode}");
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      print("An exception occurred in getMyConversations: $e");
      rethrow;
    }
  }

  Future<int> createConversation(int receiverId) async {
    final url = Uri.parse('$baseUrl/create/conversation');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['receiver_id'] = receiverId.toString();
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)['conversation']['id'];
    } else {
      throw Exception('Failed to create conversation');
    }
  }

  Future<Map<String, dynamic>> getMessagesWithUserId(int conversationId) async {
    final url = Uri.parse('$baseUrl/get/my/massage/$conversationId');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['messages'];
      return {
        'messages': data.map((json) => Message.fromJson(json)).toList(),
        'userId': responseData['user_id'],
      };
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(int conversationId, String message) async {
    final url = Uri.parse('$baseUrl/send/message/$conversationId');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['message'] = message;
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
