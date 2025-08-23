import 'package:dio/dio.dart';
import '../models/quiz_model.dart';
import '../models/quiz_models.dart';
import '../../services/auth_service.dart';

class QuestionProvider {
  final Dio _dio = AuthService.dio;

  Future<List<Question>> getBrowseableQuestions(int lessonId) async {
    try {
      final response = await _dio.get('/get/questions/options/$lessonId');
      final List<dynamic> questionsJson = response.data;
      return questionsJson.map((json) => Question.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load questions',
      );
    }
  }
}
