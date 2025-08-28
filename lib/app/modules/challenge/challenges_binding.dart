import 'package:get/get.dart';
import 'challenges_controller.dart';

class ChallengesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallengesController>(() => ChallengesController());
  }
}
