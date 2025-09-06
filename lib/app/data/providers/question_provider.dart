// import 'package:dio/dio.dart';
// import '../models/quiz_model.dart';
// import '../models/quiz_models.dart';
// import '../../services/auth_service.dart';
//
// class QuestionProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<List<Question>> getBrowseableQuestions(int lessonId) async {
//     try {
//       final response = await _dio.get('/get/questions/options/$lessonId');
//       final List<dynamic> questionsJson = response.data;
//       return questionsJson.map((json) => Question.fromJson(json)).toList();
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to load questions',
//       );
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../utils/helpers.dart';
import '../models/quiz_model.dart';

class QuestionProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Question>> getBrowseableQuestions(int lessonId) async {
    final url = Uri.parse('$baseUrl/get/questions/options/$lessonId');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> questionsJson = jsonDecode(response.body);
      return questionsJson.map((json) => Question.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load questions',
      );
    }
  }
}
