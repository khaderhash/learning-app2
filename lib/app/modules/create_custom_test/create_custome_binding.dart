import 'package:get/get.dart';
import 'create_custom_test_controller.dart';

class CreateCustomTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateCustomTestController>(() => CreateCustomTestController());
  }
}
