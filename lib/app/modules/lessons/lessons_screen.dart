import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/lesson_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/helpers.dart';
import 'lessons_controller.dart';

class LessonsScreen extends GetView<LessonsController> {
  const LessonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lessons by ${controller.teacherName}',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              controller.subjectTitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.lessonList.isEmpty) {
          return const Center(
            child: Text(
              'This teacher has not added any lessons for this subject yet.',
            ),
          );
        }
        return RefreshIndicator(
          color: primaryColor,
          onRefresh: controller.fetchLessons,
          child: ListView.builder(
            itemCount: controller.lessonList.length,
            itemBuilder: (context, index) {
              final lesson = controller.lessonList[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.play_circle_outline, size: 40),
                  title: Text(lesson.title),
                  subtitle: const Text('Tap for options'),
                  onTap: () => _showLessonOptions(context, lesson),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showLessonOptions(BuildContext context, Lesson lesson) {
    Get.dialog(
      AlertDialog(
        title: Text(lesson.title),
        content: const Text('What would you like to do?'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Browse Questions',
              style: TextStyle(color: primaryColor),
            ),
            onPressed: () {
              Get.back();
              Get.toNamed(
                Routes.BROWSE_QUESTIONS,
                arguments: {'lessonId': lesson.id, 'lessonTitle': lesson.title},
              );
            },
          ),
          TextButton(
            child: Text('Watch Video', style: TextStyle(color: primaryColor)),
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.LESSON_DETAILS, arguments: {'lesson': lesson});
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .06,
            width: MediaQuery.of(context).size.height * .1,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text('Start Test'),
              onPressed: () {
                Get.back();
                Get.toNamed(Routes.QUIZ, arguments: {'lessonId': lesson.id});
              },
            ),
          ),
        ],
      ),
    );
  }
}
