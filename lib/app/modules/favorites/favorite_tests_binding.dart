import 'package:get/get.dart';
import 'favorite_tests_controller.dart';

class FavoriteTestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteTestsController>(() => FavoriteTestsController());
  }
}
