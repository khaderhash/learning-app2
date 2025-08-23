import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/quiz_models.dart';
import '../../data/providers/question_provider.dart';

class BrowseQuestionsController extends GetxController {
  final QuestionProvider _questionProvider = QuestionProvider();

  final int lessonId = Get.arguments['lessonId'];
  final String lessonTitle = Get.arguments['lessonTitle'];

  var isLoading = true.obs;
  var questionList = <Question>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final questions = await _questionProvider.getBrowseableQuestions(
        lessonId,
      );
      questionList.assignAll(questions);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
