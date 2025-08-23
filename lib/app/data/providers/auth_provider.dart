import 'package:dio/dio.dart';

class AuthProvider {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api'));

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
      final response = await _dio.post(
        '/register',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to register');
    }
  }

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({'phone': phone, 'password': password});
      final response = await _dio.post(
        '/login',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to login');
    }
  }
}
