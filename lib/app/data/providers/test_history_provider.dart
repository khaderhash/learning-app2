import 'package:dio/dio.dart';
import '../models/test_history_model.dart';
import '../../services/auth_service.dart';

class TestHistoryProvider {
  final Dio _dio = AuthService.dio;

  Future<List<TestHistory>> getUserTests() async {
    try {
      final response = await _dio.get('/get/tests/user');
      final List<dynamic> testsJson = response.data['tests'];
      return testsJson.map((json) => TestHistory.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get user tests',
      );
    }
  }

  Future<Map<String, int>> getTestResult(int testId) async {
    try {
      final response = await _dio.get('/tests/$testId/result');
      final resultData = response.data['result'];
      return {
        'correct': resultData['correct_answers_count'],
        'incorrect': resultData['incorrect_answers_count'],
      };
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get test result',
      );
    }
  }
}
