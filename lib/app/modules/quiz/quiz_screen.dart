import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import 'quiz_controller.dart';

class QuizScreen extends GetView<QuizController> {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (controller.status.value == QuizStatus.ready) {
            return Text(
              'Question ${controller.currentPage.value + 1} of ${controller.currentTestSession.questions.length}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return const Text('Loading Test...');
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.status.value) {
          case QuizStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case QuizStatus.error:
            return Center(child: Text(controller.errorMessage.value));
          case QuizStatus.ready:
          case QuizStatus.submitting:
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.currentTestSession.questions.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionPage(
                        controller.currentTestSession.questions[index],
                      );
                    },
                  ),
                ),
                _buildBottomButton(context),
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

  Widget _buildBottomButton(BuildContext context) {
    return Obx(() {
      if (controller.status.value == QuizStatus.submitting) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        );
      }
      final isLastQuestion =
          controller.currentPage.value ==
          controller.currentTestSession.questions.length - 1;
      final isAnswered = controller.answers.containsKey(
        controller
            .currentTestSession
            .questions[controller.currentPage.value]
            .id,
      );

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * .12,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .33,
          height: MediaQuery.of(context).size.height * .06,

          child: ElevatedButton(
            onPressed: isAnswered
                ? (isLastQuestion ? controller.submitTest : controller.nextPage)
                : null,
            child: Text(isLastQuestion ? 'Submit Answers' : 'Next Question'),
          ),
        ),
      );
    });
  }
}
