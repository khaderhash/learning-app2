import 'package:get/get.dart';
import 'browse_questions_controller.dart';

class BrowseQuestionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrowseQuestionsController>(() => BrowseQuestionsController());
  }
}
