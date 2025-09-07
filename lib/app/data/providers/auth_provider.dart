import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/helpers.dart';

class AuthProvider {
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final url = Uri.parse('$baseUrl/register');
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
    final url = Uri.parse('$baseUrl/login');
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
