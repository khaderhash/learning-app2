// import 'package:dio/dio.dart';
// import '../models/test_history_model.dart';
// import '../../services/auth_service.dart';
//
// class TestHistoryProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<List<TestHistory>> getUserTests() async {
//     try {
//       final response = await _dio.get('/get/tests/user');
//       final List<dynamic> testsJson = response.data['tests'];
//       return testsJson.map((json) => TestHistory.fromJson(json)).toList();
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to get user tests',
//       );
//     }
//   }
//
//   Future<Map<String, int>> getTestResult(int testId) async {
//     try {
//       final response = await _dio.get('/tests/$testId/result');
//       final resultData = response.data['result'];
//       return {
//         'correct': resultData['correct_answers_count'],
//         'incorrect': resultData['incorrect_answers_count'],
//       };
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to get test result',
//       );
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../models/test_history_model.dart';

class TestHistoryProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<TestHistory>> getUserTests() async {
    final url = Uri.parse('$_baseUrl/get/tests/user');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> testsJson = jsonDecode(response.body)['tests'];
      return testsJson.map((json) => TestHistory.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to get user tests',
      );
    }
  }

  Future<Map<String, int>> getTestResult(int testId) async {
    final url = Uri.parse('$_baseUrl/tests/$testId/result');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final resultData = jsonDecode(response.body)['result'];
      return {
        'correct': resultData['correct_answers_count'],
        'incorrect': resultData['incorrect_answers_count'],
      };
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to get test result',
      );
    }
  }
}
