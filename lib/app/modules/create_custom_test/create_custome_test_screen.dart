import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/helpers.dart';
import 'create_custom_test_controller.dart';

class CreateCustomTestScreen extends GetView<CreateCustomTestController> {
  const CreateCustomTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Create Custom Test',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '1. Select Lessons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Note: This feature is not fully implemented. We'll create a test from a predefined set of lessons for now.",
          ),
          const SizedBox(height: 20),
          const Text(
            '2. Enter Number of Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: controller.questionsCountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Number of Questions'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.generateTest,
            child: controller.isLoading.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : const Text('Generate Test'),
          ),
        ),
      ),
    );
  }
}
