// import 'package:dio/dio.dart';
//
// class AuthProvider {
//   final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api'));
//
//   Future<Map<String, dynamic>> register({
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//   }) async {
//     try {
//       final formData = FormData.fromMap({
//         'name': name,
//         'email': email,
//         'password': password,
//         'phone': phone,
//       });
//       final response = await _dio.post(
//         '/register',
//         data: formData,
//         options: Options(headers: {'Accept': 'application/json'}),
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to register');
//     }
//   }
//
//   Future<Map<String, dynamic>> login({
//     required String phone,
//     required String password,
//   }) async {
//     try {
//       final formData = FormData.fromMap({'phone': phone, 'password': password});
//       final response = await _dio.post(
//         '/login',
//         data: formData,
//         options: Options(headers: {'Accept': 'application/json'}),
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to login');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    var request = http.MultipartRequest('POST', url)
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['phone'] = phone;
    request.headers['Accept'] = 'application/json';

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to register',
      );
    }
  }

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login');
    var request = http.MultipartRequest('POST', url)
      ..fields['phone'] = phone
      ..fields['password'] = password;
    request.headers['Accept'] = 'application/json';

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to login',
      );
    }
  }
}
