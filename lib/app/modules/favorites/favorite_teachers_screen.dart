import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import 'favorites_controller.dart';
import '../../routes/app_pages.dart';

class FavoriteTeachersScreen extends GetView<FavoritesController> {
  const FavoriteTeachersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorite Teachers',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.favoriteTeachersList.isEmpty) {
          return const Center(
            child: Text('No teachers have added you to their favorites yet.'),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchFavoriteTeachers,
          child: ListView.builder(
            itemCount: controller.favoriteTeachersList.length,
            itemBuilder: (context, index) {
              final teacher = controller.favoriteTeachersList[index];
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
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            teacher.name.substring(0, 1),
            style: TextStyle(color: Color(0xff29a4d9)),
          ),
          backgroundColor: Colors.white,
        ),
        title: Text(teacher.name),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Get.toNamed(
            Routes.FAVORITE_TESTS,
            arguments: {'teacherId': teacher.id, 'teacherName': teacher.name},
          );
        },
      ),
    );
  }
}
