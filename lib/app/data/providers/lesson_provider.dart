import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../utils/helpers.dart';
import '../models/lesson_model.dart';

class LessonProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Lesson>> getLessons(int teacherId, int subjectId) async {
    final url = Uri.parse('$baseUrl/get/lessons/teacher/$teacherId');
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
