import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/test_history_model.dart';
import 'my_tests_controller.dart';

class MyTestsScreen extends GetView<MyTestsController> {
  const MyTestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My Tests',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.testHistoryList.isEmpty) {
          return const Center(child: Text('You have not taken any tests yet.'));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchTestHistory,
          child: ListView.builder(
            itemCount: controller.testHistoryList.length,
            itemBuilder: (context, index) {
              final test = controller.testHistoryList[index];
              return _buildTestHistoryCard(context, test);
            },
          ),
        );
      }),
    );
  }

  Widget _buildTestHistoryCard(BuildContext context, TestHistory test) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.history_edu, color: Color(0xff8B5CF6)),
        title: Text(
          'Test #${test.testId}',
          style: TextStyle(color: Color(0xff8B5CF6)),
        ),
        subtitle: Text('Subject ID: ${test.subjectId}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => controller.viewTestResult(test.testId),
      ),
    );
  }
}
