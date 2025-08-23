import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/providers/quiz_provider.dart';
import '../quiz/quiz_screen.dart';

class CreateCustomTestController extends GetxController {
  final QuizProvider _quizProvider = QuizProvider();

  final questionsCountController = TextEditingController(text: '10');

  var isLoading = false.obs;

  Future<void> generateTest() async {
    final count = int.tryParse(questionsCountController.text) ?? 0;
    final lessonIds = [1, 2, 5];

    if (lessonIds.isEmpty || count <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid number of questions.',
      );
      return;
    }

    try {
      isLoading.value = true;
      final testSession = await _quizProvider.createTest(lessonIds, count);
      Get.off(
        () => const QuizScreen(),
        arguments: {'testSession': testSession},
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    questionsCountController.dispose();
    super.onClose();
  }
}
