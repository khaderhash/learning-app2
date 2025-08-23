import 'dart:io';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../services/auth_service.dart';

class ProfileProvider {
  final Dio _dio = AuthService.dio;

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get('/get/user');
      return UserModel.fromJson(response.data['user'][0]);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get profile');
    }
  }

  Future<String> updateUserImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        'user_image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
      final response = await _dio.post('/add/image/profile', data: formData);
      return response.data['user_image'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update image');
    }
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    try {
      final formData = FormData.fromMap({
        'old_password': oldPassword,
        'new_password': newPassword,
      });
      final response = await _dio.post('/change-password', data: formData);
      return response.data['message'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to change password',
      );
    }
  }
}
