import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import 'challenge_quiz_controller.dart';

class ChallengeQuizScreen extends GetView<ChallengeQuizController> {
  const ChallengeQuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (controller.status.value == ChallengeQuizStatus.ready) {
            return Text(
              'Question ${controller.currentPage.value + 1} of ${controller.questionList.length}',
            );
          }
          return const Text('Loading Challenge...');
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.status.value) {
          case ChallengeQuizStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ChallengeQuizStatus.error:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.titleLarge,
                ),
              ),
            );
          case ChallengeQuizStatus.ready:
          case ChallengeQuizStatus.submitting:
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.questionList.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionPage(controller.questionList[index]);
                    },
                  ),
                ),
                _buildBottomButton(),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildQuestionPage(Question question) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(question.questionText, style: Get.textTheme.headlineSmall),
        const SizedBox(height: 30),
        Obx(
          () => Column(
            children: question.options
                .map(
                  (option) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: RadioListTile<int>(
                      title: Text(
                        option.optionText,
                        style: const TextStyle(fontSize: 16),
                      ),
                      value: option.id,
                      groupValue: controller.answers[question.id],
                      onChanged: (value) =>
                          controller.selectAnswer(question.id, value!),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Obx(() {
      if (controller.status.value == ChallengeQuizStatus.submitting) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        );
      }
      final isLastQuestion =
          controller.currentPage.value == controller.questionList.length - 1;
      final isAnswered = controller.answers.containsKey(
        controller.questionList[controller.currentPage.value].id,
      );

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: isAnswered
              ? (isLastQuestion
                    ? controller.submitChallenge
                    : controller.nextPage)
              : null,
          child: Text(isLastQuestion ? 'Submit Challenge' : 'Next Question'),
        ),
      );
    });
  }
}
