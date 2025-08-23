import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../routes/app_pages.dart';
import 'subjects_controller.dart';

class SubjectsScreen extends GetView<SubjectsController> {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'All Subjects',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff29a4d9)),
          );
        }
        if (controller.subjectList.isEmpty) {
          return const Center(
            child: Text('There are no subjects available at the moment.'),
          );
        }
        return RefreshIndicator(
          color: Color(0xff29a4d9),
          onRefresh: controller.fetchSubjects,
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: controller.subjectList.length,
            itemBuilder: (context, index) {
              final subject = controller.subjectList[index];
              return _buildSubjectCard(context, subject);
            },
          ),
        );
      }),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            Routes.TEACHERS,
            arguments: {'subjectId': subject.id, 'subjectTitle': subject.title},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  subject.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Price: ${subject.price}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
