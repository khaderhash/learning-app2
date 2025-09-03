import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/points_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/helpers.dart';
import 'quiz_result_controller.dart';
import 'review_answers_screen.dart';

class QuizResultScreen extends GetView<QuizResultController> {
  const QuizResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result (ID: ${controller.testId})'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
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
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          final correct = controller.result['correct'] ?? 0;
          final incorrect = controller.result['incorrect'] ?? 0;
          final total = correct + incorrect;
          final double scorePercentage = total > 0
              ? (correct / total) * 100
              : 0;
          final bool isPassed = scorePercentage >= 50;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPassed
                            ? Icons.emoji_events
                            : Icons.sentiment_dissatisfied,
                        color: isPassed ? Colors.amber : Colors.redAccent,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your Quiz Result',
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildResultRow(
                        'Correct Answers:',
                        '$correct out of $total',
                      ),
                      const SizedBox(height: 15),
                      _buildResultRow(
                        'Your Score:',
                        '${scorePercentage.toStringAsFixed(1)}%',
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Status:', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            isPassed ? 'Passed' : 'Failed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isPassed ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (controller.points.isNotEmpty) ...[
                        const Divider(height: 30),
                        _buildPointsSection(controller.points),
                      ],
                      const Divider(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: BorderSide(color: primaryColor),
                          ),
                          icon: const Icon(Icons.reviews_outlined),
                          label: const Text('Review Answers'),
                          onPressed: () {
                            Get.to(
                              () => ReviewAnswersScreen(
                                testId: controller.testId,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          icon: const Icon(Icons.home_outlined),
                          label: const Text('Return to Home Page'),
                          onPressed: () => Get.offAllNamed(Routes.MAIN),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResultRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF008080),
          ),
        ),
      ],
    );
  }

  Widget _buildPointsSection(List<PointsRecord> points) {
    final totalPoints = points.fold<int>(0, (sum, item) => sum + item.points);
    return Column(
      children: [
        Text(
          'Total Points Earned',
          style: Get.textTheme.titleMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Text(
          totalPoints.toString(),
          style: Get.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF008080),
          ),
        ),
      ],
    );
  }
}
