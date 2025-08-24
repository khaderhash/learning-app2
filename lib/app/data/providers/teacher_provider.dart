// import 'package:dio/dio.dart';
// import '../models/teacher_model.dart';
// import '../../services/auth_service.dart';
//
// class TeacherProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<List<Teacher>> getTeachersForSubject(int subjectId) async {
//     try {
//       final response = await _dio.get('/get/teachers/subject/$subjectId');
//       final List<dynamic> teacherJsonList = response.data;
//       return teacherJsonList.map((json) => Teacher.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to load teachers');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../models/teacher_model.dart';

class TeacherProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Teacher>> getTeachersForSubject(int subjectId) async {
    final url = Uri.parse('$_baseUrl/get/teachers/subject/$subjectId');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final List<dynamic> teacherJsonList = jsonDecode(response.body);
      return teacherJsonList.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load teachers',
      );
    }
  }
}
