import 'package:dio/dio.dart';
import '../models/lesson_model.dart';
import '../../services/auth_service.dart';

class LessonProvider {
  final Dio _dio = AuthService.dio;

  Future<List<Lesson>> getLessons(int teacherId, int subjectId) async {
    try {
      final formData = FormData.fromMap({'subject_id': subjectId});
      final response = await _dio.post(
        '/get/lessons/teacher/$teacherId',
        data: formData,
      );
      final List<dynamic> lessonJsonList = response.data['lessons'];
      return lessonJsonList.map((json) => Lesson.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(e.response?.data['message'] ?? 'Failed to load lessons');
    }
  }
}
