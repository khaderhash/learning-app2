import 'package:get/get.dart';
import 'lessons_controller.dart';

class LessonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonsController>(() => LessonsController());
  }
}
