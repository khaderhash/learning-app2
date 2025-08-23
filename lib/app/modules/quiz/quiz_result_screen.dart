import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class QuizResultScreen extends StatelessWidget {
  final Map<String, int> result;
  const QuizResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final correct = result['correct'] ?? 0;
    final incorrect = result['incorrect'] ?? 0;
    final total = correct + incorrect;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Test Result',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $correct / $total',
              style: Get.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Correct Answers: $correct',
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
            Text(
              'Incorrect Answers: $incorrect',
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: MediaQuery.of(context).size.width * .33,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.MAIN),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
