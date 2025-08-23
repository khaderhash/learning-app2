import 'package:get/get.dart';
import 'package:student_app2/app/modules/profile/profile_controller.dart';

class SubjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
