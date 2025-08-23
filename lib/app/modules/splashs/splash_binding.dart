import 'package:get/get.dart';
import 'splash_controller.dart';
import '../../services/storage_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(storageService: Get.find<StorageService>()),
    );
  }
}
