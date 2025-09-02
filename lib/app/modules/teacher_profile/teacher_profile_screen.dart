import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../utils/helpers.dart';
import 'teacher_profile_controller.dart';

class TeacherProfileScreen extends GetView<TeacherProfileController> {
  const TeacherProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          controller.teacher.name,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        final profile = controller.fullProfile.value;
        final details = profile.details;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: primaryColor,
                radius: 50,
                backgroundImage: profile.baseInfo.profileImageUrl != null
                    ? NetworkImage(profile.baseInfo.profileImageUrl!)
                    : null,
                child: profile.baseInfo.profileImageUrl == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 10),
              Text(
                profile.baseInfo.name,
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),

              if (!controller.isLoading.value && details != null) ...[
                if (details.specialization != null)
                  Text(
                    details.specialization!,
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 20),
                if (details.bio != null)
                  Text(
                    details.bio!,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyLarge,
                  ),
              ],

              const Divider(height: 40),
              const Text(
                'Rate this teacher',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: controller.currentRating.value,
                minRating: 1,
                itemCount: 5,
                onRatingUpdate: (rating) =>
                    controller.currentRating.value = rating,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: controller.isSubmittingRating.value
                      ? null
                      : controller.submitRating,
                  child: controller.isSubmittingRating.value
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: const Text('Submit Rating'),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
