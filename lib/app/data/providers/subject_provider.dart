// import 'package:dio/dio.dart';
// import 'package:get/get_connect/http/src/multipart/form_data.dart'
//     hide FormData;
// import '../models/subject_model.dart';
// import '../../services/auth_service.dart';
//
// class SubjectProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<List<Subject>> getSubjects() async {
//     try {
//       final response = await _dio.get('/get/subjects');
//       final List<dynamic> subjectJsonList = response.data['subjects'];
//       return subjectJsonList.map((json) => Subject.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to load subjects');
//     }
//   }
//
//   Future<String> requestToJoinSubject(int subjectId, int teacherId) async {
//     try {
//       final formData = FormData.fromMap({
//         'subject_id': subjectId,
//         'teacher_id': teacherId,
//       });
//       final response = await _dio.post(
//         '/student/request-subject',
//         data: formData,
//       );
//       return response.data['message'];
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to submit request',
//       );
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../models/subject_model.dart';

class SubjectProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Subject>> getSubjects() async {
    final url = Uri.parse('$_baseUrl/get/subjects');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> subjectJsonList = jsonDecode(
        response.body,
      )['subjects'];
      return subjectJsonList.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load subjects',
      );
    }
  }

  Future<String> requestToJoinSubject(int subjectId, int teacherId) async {
    final url = Uri.parse('$_baseUrl/student/request-subject');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['subject_id'] = subjectId.toString()
      ..fields['teacher_id'] = teacherId.toString();

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to submit request',
      );
    }
  }
}
