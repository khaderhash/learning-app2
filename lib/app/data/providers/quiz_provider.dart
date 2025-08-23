import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/quiz_model.dart';
import '../../services/auth_service.dart';

class QuizProvider {
  final Dio _dio = AuthService.dio;

  Future<TestSession> createTest(
    List<int> lessonIds,
    int questionsCount,
  ) async {
    try {
      final formData = FormData.fromMap({
        'lesson_ids': jsonEncode(lessonIds),
        'questions_count': questionsCount.toString(),
      });
      final response = await _dio.post('/create/test/student', data: formData);

      if (response.statusCode != 201) {
        throw Exception('Server error: ${response.statusCode}');
      }
      final testData = response.data['test'];
      final questionsData = response.data['questions'] as List;
      return TestSession(
        testId: testData['id'],
        questions: questionsData.map((q) => Question.fromJson(q)).toList(),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create test');
    }
  }

  Future<Map<String, int>> submitAnswers(
    int testId,
    Map<int, int> answers,
  ) async {
    try {
      final Map<String, String> formattedAnswers = {};
      answers.forEach((key, value) {
        formattedAnswers['answers[$key]'] = value.toString();
      });
      final formData = FormData.fromMap(formattedAnswers);
      final response = await _dio.post('/tests/$testId/submit', data: formData);
      return {
        'correct': response.data['correct_answers_count'],
        'incorrect': response.data['incorrect_answers_count'],
      };
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to submit answers',
      );
    }
  }
}
