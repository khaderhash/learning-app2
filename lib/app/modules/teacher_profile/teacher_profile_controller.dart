import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/models/teacher_model.dart';
import '../../data/models/teacher_profile_model.dart';
import '../../data/providers/teacher_provider.dart';

class TeacherProfileController extends GetxController {
  final TeacherProvider _provider = TeacherProvider();
  final Teacher teacher = Get.arguments['teacher'];

  final box = GetStorage();
  var isLoading = true.obs;
  late Rx<TeacherFullProfile> fullProfile;
  var currentRating = 3.0.obs;
  var isSubmittingRating = false.obs;

  @override
  void onInit() {
    super.onInit();

    double? savedRating = box.read('teacher_rating_${teacher.id}');
    currentRating.value = savedRating ?? 3.0;

    fullProfile = TeacherFullProfile(baseInfo: teacher).obs;
    fetchProfileDetails();
  }

  Future<void> fetchProfileDetails() async {
    try {
      isLoading.value = true;
      final details = await _provider.getTeacherProfileDetails(teacher.id);
      fullProfile.value = TeacherFullProfile(
        baseInfo: teacher,
        details: details,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRating() async {
    try {
      isSubmittingRating.value = true;
      final ratingToSubmit = currentRating.value;

      box.write('teacher_rating_${teacher.id}', ratingToSubmit);

      final message = await _provider.rateTeacher(
        teacher.id,
        ratingToSubmit.toInt(),
      );

      Get.snackbar('Success', message, backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    } finally {
      isSubmittingRating.value = false;
    }
  }
}
