import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart'
    hide FormData;
import '../models/subject_model.dart';
import '../../services/auth_service.dart';

class SubjectProvider {
  final Dio _dio = AuthService.dio;

  Future<List<Subject>> getSubjects() async {
    try {
      final response = await _dio.get('/get/subjects');
      final List<dynamic> subjectJsonList = response.data['subjects'];
      return subjectJsonList.map((json) => Subject.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load subjects');
    }
  }

  Future<String> requestToJoinSubject(int subjectId, int teacherId) async {
    try {
      final formData = FormData.fromMap({
        'subject_id': subjectId,
        'teacher_id': teacherId,
      });
      final response = await _dio.post(
        '/student/request-subject',
        data: formData,
      );
      return response.data['message'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to submit request',
      );
    }
  }
}
