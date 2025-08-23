import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  final StorageService storageService;
  SplashController({required this.storageService});

  @override
  void onReady() {
    super.onReady();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final token = await storageService.getToken();

      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      print("Error during auth check: $e");
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
