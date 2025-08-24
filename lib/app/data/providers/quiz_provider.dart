// import 'dart:convert';
// import 'package:dio/dio.dart';
// import '../models/quiz_model.dart';
// import '../../services/auth_service.dart';
//
// class QuizProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<TestSession> createTest(
//     List<int> lessonIds,
//     int questionsCount,
//   ) async {
//     try {
//       final formData = FormData.fromMap({
//         'lesson_ids': jsonEncode(lessonIds),
//         'questions_count': questionsCount.toString(),
//       });
//       final response = await _dio.post('/create/test/student', data: formData);
//
//       if (response.statusCode != 201) {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//       final testData = response.data['test'];
//       final questionsData = response.data['questions'] as List;
//       return TestSession(
//         testId: testData['id'],
//         questions: questionsData.map((q) => Question.fromJson(q)).toList(),
//       );
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to create test');
//     }
//   }
//
//   Future<Map<String, int>> submitAnswers(
//     int testId,
//     Map<int, int> answers,
//   ) async {
//     try {
//       final Map<String, String> formattedAnswers = {};
//       answers.forEach((key, value) {
//         formattedAnswers['answers[$key]'] = value.toString();
//       });
//       final formData = FormData.fromMap(formattedAnswers);
//       final response = await _dio.post('/tests/$testId/submit', data: formData);
//       return {
//         'correct': response.data['correct_answers_count'],
//         'incorrect': response.data['incorrect_answers_count'],
//       };
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to submit answers',
//       );
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../models/quiz_model.dart';
import '../models/quiz_models.dart';

class QuizProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<TestSession> createTest(
    List<int> lessonIds,
    int questionsCount,
  ) async {
    final url = Uri.parse('$_baseUrl/create/test/student');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['lesson_ids'] = jsonEncode(lessonIds)
      ..fields['questions_count'] = questionsCount.toString();

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final testData = responseData['test'];
      final questionsData = responseData['questions'] as List;
      return TestSession(
        testId: testData['id'],
        questions: questionsData.map((q) => Question.fromJson(q)).toList(),
      );
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to create test',
      );
    }
  }

  Future<Map<String, int>> submitAnswers(
    int testId,
    Map<int, int> answers,
  ) async {
    final url = Uri.parse('$_baseUrl/tests/$testId/submit');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders());
    answers.forEach((key, value) {
      request.fields['answers[$key]'] = value.toString();
    });

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'correct': data['correct_answers_count'],
        'incorrect': data['incorrect_answers_count'],
      };
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to submit answers',
      );
    }
  }
}
