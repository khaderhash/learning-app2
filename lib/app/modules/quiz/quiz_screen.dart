import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../utils/helpers.dart';
import 'quiz_controller.dart';

class QuizScreen extends GetView<QuizController> {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() {
          if (controller.status.value == QuizStatus.ready) {
            return Text(
              'Question ${controller.currentPage.value + 1} of ${controller.currentTestSession.questions.length}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return const Text(
            'Loading Test...',
            style: TextStyle(color: Colors.black),
          );
        }),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, const Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          switch (controller.status.value) {
            case QuizStatus.loading:
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            case QuizStatus.error:
              return Center(child: Text(controller.errorMessage.value));
            case QuizStatus.ready:
            case QuizStatus.submitting:
              return Column(
                children: [
                  const SizedBox(height: kToolbarHeight + 20),
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
      ),
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
        return Padding(
          padding: const EdgeInsets.all(24),
          child: CircularProgressIndicator(color: primaryColor),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isAnswered
                ? (isLastQuestion ? controller.submitTest : controller.nextPage)
                : null,
            child: Text(
              isLastQuestion ? 'Submit Answers' : 'Next Question',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    });
  }
}
