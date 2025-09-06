import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../utils/helpers.dart';
import '../models/challenge_model.dart';
import '../models/quiz_model.dart';

class ChallengeProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Challenge>> getChallenges() async {
    final url = Uri.parse('$baseUrl/get/challenges/student');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final List<dynamic> challengesJson = jsonDecode(response.body);
      return challengesJson.map((json) => Challenge.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load challenges',
      );
    }
  }

  Future<List<Question>> getChallengeQuestions(int challengeId) async {
    final url = Uri.parse('$baseUrl/get/challenge/$challengeId');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final List<dynamic> questionsJson = jsonDecode(response.body);
      return questionsJson.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ??
            'Failed to get challenge questions',
      );
    }
  }

  Future<Map<String, int>> submitChallenge(
    int challengeId,
    Map<int, int> answers,
  ) async {
    final url = Uri.parse('$baseUrl/submit/challenge/$challengeId');
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
        jsonDecode(response.body)['message'] ?? 'Failed to submit challenge',
      );
    }
  }
}
