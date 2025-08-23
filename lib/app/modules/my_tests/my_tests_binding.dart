import 'package:get/get.dart';
import 'my_tests_controller.dart';

class MyTestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTestsController>(() => MyTestsController());
  }
}
