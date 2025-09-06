import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../utils/helpers.dart';
import '../models/user_model.dart';
import '../../services/storage_service.dart';

class ProfileProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<UserModel> getUserProfile() async {
    final url = Uri.parse('$baseUrl/get/user');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['user'][0]);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to get profile',
      );
    }
  }

  Future<String> updateUserImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/add/image/profile');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..files.add(
        await http.MultipartFile.fromPath('user_image', imageFile.path),
      );

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['user_image'];
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to update image',
      );
    }
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    final url = Uri.parse('$baseUrl/change-password');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(await _getHeaders())
      ..fields['old_password'] = oldPassword
      ..fields['new_password'] = newPassword;

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to change password',
      );
    }
  }
}
