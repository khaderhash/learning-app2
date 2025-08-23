import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import '../../routes/app_pages.dart';
import '../lessons/lessons_screen.dart';
import 'teachers_controller.dart';

class TeachersScreen extends GetView<TeachersController> {
  const TeachersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          controller.subjectTitle,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.teacherList.isEmpty) {
          return const Center(
            child: Text('No teachers found for this subject.'),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchTeachers,
          child: ListView.builder(
            itemCount: controller.teacherList.length,
            itemBuilder: (context, index) {
              final teacher = controller.teacherList[index];
              return _buildTeacherCard(context, teacher);
            },
          ),
        );
      }),
    );
  }

  Widget _buildTeacherCard(BuildContext context, Teacher teacher) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xff29a4d9),
                backgroundImage: teacher.profileImageUrl != null
                    ? NetworkImage(teacher.profileImageUrl!)
                    : null,
                child: teacher.profileImageUrl == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              title: Text(teacher.name),
              subtitle: const Text('Tap to view lessons (after approval)'),
              onTap: () {
                Get.toNamed(
                  Routes.LESSONS,
                  arguments: {
                    'teacherId': teacher.id,
                    'teacherName': teacher.name,
                    'subjectId': controller.subjectId,
                    'subjectTitle': controller.subjectTitle,
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(
                () => ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  icon: controller.isRequestingJoin.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_circle_outline),
                  label: const Text('Request to Join'),
                  onPressed: controller.isRequestingJoin.value
                      ? null
                      : () => controller.requestToJoin(teacher.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
