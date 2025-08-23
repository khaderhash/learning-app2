import 'package:dio/dio.dart';
import '../models/teacher_model.dart';
import '../../services/auth_service.dart';

class TeacherProvider {
  final Dio _dio = AuthService.dio;

  Future<List<Teacher>> getTeachersForSubject(int subjectId) async {
    try {
      final response = await _dio.get('/get/teachers/subject/$subjectId');
      final List<dynamic> teacherJsonList = response.data;
      return teacherJsonList.map((json) => Teacher.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load teachers');
    }
  }
}
