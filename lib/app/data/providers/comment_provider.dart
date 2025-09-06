import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../utils/helpers.dart';
import '../models/comment_model.dart';

class CommentProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Comment>> getComments(int lessonId) async {
    final url = Uri.parse('$baseUrl/get/comment/lesson/$lessonId');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> commentsJson = jsonDecode(response.body);
      return commentsJson.map((json) => Comment.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load comments',
      );
    }
  }

  Future<void> addComment({
    required int lessonId,
    required String content,
    int? parentId,
  }) async {
    final url = Uri.parse('$baseUrl/add/comment');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['lesson_id'] = lessonId.toString()
      ..fields['content'] = content;
    if (parentId != null) {
      request.fields['parent_id'] = parentId.toString();
    }

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode != 201) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to add comment',
      );
    }
  }

  Future<List<Comment>> getReplies(int commentId) async {
    final url = Uri.parse('$baseUrl/get/replies/comment/$commentId');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> repliesJson = jsonDecode(response.body);
      return repliesJson.map((json) => Comment.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load replies',
      );
    }
  }
}
