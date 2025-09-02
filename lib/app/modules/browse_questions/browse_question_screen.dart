import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/quiz_models.dart';
import '../../utils/helpers.dart';
import 'browse_questions_controller.dart';

class BrowseQuestionsScreen extends GetView<BrowseQuestionsController> {
  const BrowseQuestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Browse Questions',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              controller.lessonTitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.questionList.isEmpty) {
          return const Center(
            child: Text('No questions available for browsing in this lesson.'),
          );
        }
        return RefreshIndicator(
          color: primaryColor,
          onRefresh: controller.fetchQuestions,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.questionList.length,
            itemBuilder: (context, index) {
              return _buildQuestionCard(
                context,
                controller.questionList[index],
                index + 1,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    Question question,
    int questionNumber,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q$questionNumber: ${question.questionText}',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...question.options.map((option) => _buildOptionTile(option)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(Option option) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: option.isCorrect
            ? Colors.green.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: option.isCorrect ? Colors.green : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            option.isCorrect
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: option.isCorrect ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(option.optionText)),
        ],
      ),
    );
  }
}
