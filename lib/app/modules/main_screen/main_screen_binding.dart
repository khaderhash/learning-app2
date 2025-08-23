import 'package:get/get.dart';
import '../dashboard/dashboard_controller.dart';
import '../my_tests/my_tests_controller.dart';
import '../profile/profile_controller.dart';
import 'main_screen_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainScreenController>(() => MainScreenController());

    Get.put(DashboardController());

    Get.lazyPut<MyTestsController>(() => MyTestsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
