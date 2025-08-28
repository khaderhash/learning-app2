import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import 'favorite_tests_controller.dart';
import '../quiz/quiz_screen.dart';

class FavoriteTestsScreen extends GetView<FavoriteTestsController> {
  const FavoriteTestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Favorite Tests by ${controller.teacherName},'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff29a4d9)),
          );
        }
        if (controller.favoriteTestsList.isEmpty) {
          return const Center(
            child: Text('This teacher has not added any favorite tests yet.'),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchFavoriteTests,
          child: ListView.builder(
            itemCount: controller.favoriteTestsList.length,
            itemBuilder: (context, index) {
              final test = controller.favoriteTestsList[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(
                    Icons.quiz_outlined,
                    color: Color(0xff29a4d9),
                  ),
                  title: Text('Favorite Test #${test.testId}'),
                  subtitle: Text('${test.questions.length} Questions'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Get.to(
                    //   () => const QuizScreen(),
                    //   arguments: {'testSession': test},
                    Get.toNamed(Routes.QUIZ, arguments: {'testSession': test});
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
