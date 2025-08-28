import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../data/providers/challenge_provider.dart';
import '../quiz/quiz_result_screen.dart';

enum ChallengeQuizStatus { loading, ready, submitting, finished, error }

class ChallengeQuizController extends GetxController {
  final ChallengeProvider _provider = ChallengeProvider();

  final int challengeId = Get.arguments['challengeId'];

  var status = ChallengeQuizStatus.loading.obs;
  var errorMessage = ''.obs;
  var questionList = <Question>[].obs;

  final pageController = PageController();
  final answers = <int, int>{}.obs;
  var currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page?.round() ?? 0;
    });
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      status.value = ChallengeQuizStatus.loading;
      final questions = await _provider.getChallengeQuestions(challengeId);
      if (questions.isEmpty) {
        throw Exception("No questions found for this challenge.");
      }
      questionList.assignAll(questions);
      status.value = ChallengeQuizStatus.ready;
    } catch (e) {
      errorMessage.value = e.toString();
      status.value = ChallengeQuizStatus.error;
    }
  }

  void selectAnswer(int questionId, int optionId) {
    answers[questionId] = optionId;
  }

  void nextPage() {
    if (currentPage.value < questionList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> submitChallenge() async {
    try {
      status.value = ChallengeQuizStatus.submitting;
      final result = await _provider.submitChallenge(challengeId, answers);
      status.value = ChallengeQuizStatus.finished;
      Get.off(() => QuizResultScreen(result: result));
    } catch (e) {
      errorMessage.value = e.toString();
      status.value = ChallengeQuizStatus.error;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
