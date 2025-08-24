// import 'package:dio/dio.dart';
// import '../models/quiz_model.dart';
// import '../models/teacher_model.dart';
// import '../../services/auth_service.dart';
//
// class FavoritesProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<List<Teacher>> getFavoriteTeachers() async {
//     try {
//       final response = await _dio.get('/get/teachers/favorite/student');
//       final List<dynamic> teachersJson = response.data['teachers'];
//       return teachersJson.map((json) => Teacher.fromJson(json)).toList();
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to load favorite teachers',
//       );
//     }
//   }
//
//   Future<List<TestSession>> getFavoriteTests(int teacherId) async {
//     try {
//       final response = await _dio.get('/get/tests/from/favorite/$teacherId');
//       final List<dynamic> testsJson = response.data['test '];
//       return testsJson.map((json) {
//         final questionsData = json['questions'] as List;
//         return TestSession(
//           testId: json['id'],
//           questions: questionsData.map((q) => Question.fromJson(q)).toList(),
//         );
//       }).toList();
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to load favorite tests',
//       );
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../models/quiz_model.dart';
import '../models/teacher_model.dart';

class FavoritesProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Teacher>> getFavoriteTeachers() async {
    final url = Uri.parse('$_baseUrl/get/teachers/favorite/student');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final List<dynamic> teachersJson = jsonDecode(response.body)['teachers'];
      return teachersJson.map((json) => Teacher.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ??
            'Failed to load favorite teachers',
      );
    }
  }

  Future<List<TestSession>> getFavoriteTests(int teacherId) async {
    final url = Uri.parse('$_baseUrl/get/tests/from/favorite/$teacherId');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final List<dynamic> testsJson = jsonDecode(response.body)['test '];
      return testsJson.map((json) {
        final questionsData = json['questions'] as List;
        return TestSession(
          testId: json['id'],
          questions: questionsData.map((q) => Question.fromJson(q)).toList(),
        );
      }).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load favorite tests',
      );
    }
  }
}
