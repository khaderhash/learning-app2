import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/points_model.dart';
import '../../routes/app_pages.dart';

class QuizResultScreen extends StatelessWidget {
  final Map<String, int> result;
  final List<PointsRecord>? points;

  const QuizResultScreen({Key? key, required this.result, this.points})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final correct = result['correct'] ?? 0;
    final incorrect = result['incorrect'] ?? 0;
    final total = correct + incorrect;
    final double scorePercentage = total > 0 ? (correct / total) * 100 : 0;
    final bool isPassed = scorePercentage >= 50;

    const Color primaryColor = Color(0xff29a4d9);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Quiz Result'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                    ),
                  ),

                  const SizedBox(height: 25),

                  _buildResultRow('Correct Answers:', '$correct out of $total'),
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

                  const Divider(height: 40),

                  if (points != null && points!.isNotEmpty) ...[
                    _buildPointsSection(),
                    const Divider(height: 40),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.home_outlined),
                      label: const Text(
                        'Return to Home Page',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () => Get.offAllNamed(Routes.MAIN),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPointsSection() {
    final totalPoints =
        points?.fold<int>(0, (sum, item) => sum + item.points) ?? 0;
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
            color: Colors.amber[800],
          ),
        ),
      ],
    );
  }
}
