import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../data/providers/quiz_provider.dart';
import 'quiz_result_screen.dart';

enum QuizStatus { loading, ready, submitting, finished, error }

class QuizController extends GetxController {
  final QuizProvider _quizProvider = QuizProvider();

  final int? lessonId = Get.arguments['lessonId'];
  final TestSession? testSession = Get.arguments['testSession'];

  var status = QuizStatus.loading.obs;
  var errorMessage = ''.obs;
  late TestSession currentTestSession;

  final pageController = PageController();
  final answers = <int, int>{}.obs;
  var currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page?.round() ?? 0;
    });
    _startTest();
  }

  Future<void> _startTest() async {
    try {
      status.value = QuizStatus.loading;
      if (testSession != null) {
        currentTestSession = testSession!;
      } else if (lessonId != null) {
        currentTestSession = await _quizProvider.createTest([lessonId!], 10);
      } else {
        throw Exception("No lessonId or testSession provided");
      }

      if (currentTestSession.questions.isEmpty) {
        throw Exception("No questions found for this test.");
      }
      status.value = QuizStatus.ready;
    } catch (e) {
      errorMessage.value = e.toString();
      status.value = QuizStatus.error;
    }
  }

  void selectAnswer(int questionId, int optionId) {
    answers[questionId] = optionId;
  }

  void nextPage() {
    if (currentPage.value < currentTestSession.questions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> submitTest() async {
    try {
      status.value = QuizStatus.submitting;
      final result = await _quizProvider.submitAnswers(
        currentTestSession.testId,
        answers,
      );
      status.value = QuizStatus.finished;
      Get.off(() => QuizResultScreen(result: result));
    } catch (e) {
      errorMessage.value = e.toString();
      status.value = QuizStatus.error;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
