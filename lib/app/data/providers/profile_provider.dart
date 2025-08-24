// import 'dart:io';
// import 'package:dio/dio.dart';
// import '../models/user_model.dart';
// import '../../services/auth_service.dart';
//
// class ProfileProvider {
//   final Dio _dio = AuthService.dio;
//
//   Future<UserModel> getUserProfile() async {
//     try {
//       final response = await _dio.get('/get/user');
//       return UserModel.fromJson(response.data['user'][0]);
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to get profile');
//     }
//   }
//
//   Future<String> updateUserImage(File imageFile) async {
//     try {
//       String fileName = imageFile.path.split('/').last;
//       final formData = FormData.fromMap({
//         'user_image': await MultipartFile.fromFile(
//           imageFile.path,
//           filename: fileName,
//         ),
//       });
//       final response = await _dio.post('/add/image/profile', data: formData);
//       return response.data['user_image'];
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to update image');
//     }
//   }
//
//   Future<String> changePassword(String oldPassword, String newPassword) async {
//     try {
//       final formData = FormData.fromMap({
//         'old_password': oldPassword,
//         'new_password': newPassword,
//       });
//       final response = await _dio.post('/change-password', data: formData);
//       return response.data['message'];
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data['message'] ?? 'Failed to change password',
//       );
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../../services/storage_service.dart';

class ProfileProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<UserModel> getUserProfile() async {
    final url = Uri.parse('$_baseUrl/get/user');
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
    final url = Uri.parse('$_baseUrl/add/image/profile');
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
    final url = Uri.parse('$_baseUrl/change-password');
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
