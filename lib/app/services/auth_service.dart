import 'package:dio/dio.dart';
import 'storage_service.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(AuthInterceptor());

  static Dio get dio => _dio;

  Future<AuthService> init() async {
    return this;
  }
}

class AuthInterceptor extends Interceptor {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
