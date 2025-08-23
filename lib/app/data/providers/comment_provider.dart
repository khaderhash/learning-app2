import 'package:dio/dio.dart';
import '../models/comment_model.dart';
import '../../services/auth_service.dart';

class CommentProvider {
  final Dio _dio = AuthService.dio;

  Future<List<Comment>> getComments(int lessonId) async {
    try {
      final response = await _dio.get('/get/comment/lesson/$lessonId');
      final List<dynamic> commentsJson = response.data;
      return commentsJson.map((json) => Comment.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(e.response?.data['message'] ?? 'Failed to load comments');
    }
  }

  Future<void> addComment({
    required int lessonId,
    required String content,
    int? parentId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'lesson_id': lessonId,
        'content': content,
        if (parentId != null) 'parent_id': parentId,
      });
      await _dio.post('/add/comment', data: formData);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to add comment');
    }
  }

  Future<List<Comment>> getReplies(int commentId) async {
    try {
      final response = await _dio.get('/get/replies/comment/$commentId');
      final List<dynamic> repliesJson = response.data;
      return repliesJson.map((json) => Comment.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(e.response?.data['message'] ?? 'Failed to load replies');
    }
  }
}
