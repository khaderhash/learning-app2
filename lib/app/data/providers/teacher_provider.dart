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
import '../../utils/helpers.dart';
import '../models/teacher_model.dart';
import '../models/teacher_profile_model.dart';

class TeacherProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Teacher>> getTeachersForSubject(int subjectId) async {
    final url = Uri.parse('$baseUrl/get/teachers/subject/$subjectId');
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

  Future<List<Teacher>> getAllTeachers() async {
    final url = Uri.parse('$baseUrl/get/teachers');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> teacherJsonList = jsonDecode(response.body);
      return teacherJsonList.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load all teachers',
      );
    }
  }

  Future<TeacherProfile> getTeacherProfile(int teacherId) async {
    final url = Uri.parse('$baseUrl/get/profile/teacher/$teacherId');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      return TeacherProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ??
            'Failed to load teacher profile',
      );
    }
  }

  Future<String> rateTeacher(int teacherId, int rating) async {
    final url = Uri.parse('$baseUrl/add/rating/$teacherId');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['rating'] = rating.toString();

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to submit rating',
      );
    }
  }

  Future<TeacherProfile> getTeacherProfileDetails(int teacherId) async {
    final url = Uri.parse('$baseUrl/get/profile/teacher/$teacherId');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      return TeacherProfile.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return TeacherProfile();
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ??
            'Failed to load teacher profile',
      );
    }
  }
}
