import 'package:get/get.dart';
import 'challenge_quiz_controller.dart';

class ChallengeQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallengeQuizController>(() => ChallengeQuizController());
  }
}
