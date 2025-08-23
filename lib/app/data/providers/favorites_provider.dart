import 'package:dio/dio.dart';
import '../models/quiz_model.dart';
import '../models/teacher_model.dart';
import '../../services/auth_service.dart';

class FavoritesProvider {
  final Dio _dio = AuthService.dio;

  Future<List<Teacher>> getFavoriteTeachers() async {
    try {
      final response = await _dio.get('/get/teachers/favorite/student');
      final List<dynamic> teachersJson = response.data['teachers'];
      return teachersJson.map((json) => Teacher.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load favorite teachers',
      );
    }
  }

  Future<List<TestSession>> getFavoriteTests(int teacherId) async {
    try {
      final response = await _dio.get('/get/tests/from/favorite/$teacherId');
      final List<dynamic> testsJson = response.data['test '];
      return testsJson.map((json) {
        final questionsData = json['questions'] as List;
        return TestSession(
          testId: json['id'],
          questions: questionsData.map((q) => Question.fromJson(q)).toList(),
        );
      }).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load favorite tests',
      );
    }
  }
}
