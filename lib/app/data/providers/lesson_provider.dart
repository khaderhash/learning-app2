// import 'package:dio/dio.dart';
// import '../models/lesson_model.dart';
// import '../../services/auth_service.dart';
//
// class LessonProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<List<Lesson>> getLessons(int teacherId, int subjectId) async {
//     try {
//       final formData = FormData.fromMap({'subject_id': subjectId});
//       final response = await _dio.post(
//         '/get/lessons/teacher/$teacherId',
//         data: formData,
//       );
//       final List<dynamic> lessonJsonList = response.data['lessons'];
//       return lessonJsonList.map((json) => Lesson.fromJson(json)).toList();
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(e.response?.data['message'] ?? 'Failed to load lessons');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../models/lesson_model.dart';

class LessonProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Lesson>> getLessons(int teacherId, int subjectId) async {
    final url = Uri.parse('$_baseUrl/get/lessons/teacher/$teacherId');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['subject_id'] = subjectId.toString();

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final List<dynamic> lessonJsonList = jsonDecode(response.body)['lessons'];
      return lessonJsonList.map((json) => Lesson.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load lessons',
      );
    }
  }
}
