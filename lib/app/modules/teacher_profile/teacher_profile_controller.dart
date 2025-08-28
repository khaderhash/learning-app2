import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import '../../data/models/teacher_profile_model.dart';
import '../../data/providers/teacher_provider.dart';
import 'package:flutter/material.dart';

class TeacherProfileController extends GetxController {
  final TeacherProvider _provider = TeacherProvider();
  double? _lastSubmittedRating;

  final Teacher teacher = Get.arguments['teacher'];

  var isLoading = true.obs;
  late Rx<TeacherFullProfile> fullProfile;

  var currentRating = 3.0.obs;
  var isSubmittingRating = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentRating.value = _lastSubmittedRating ?? 3.0;
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
      final message = await _provider.rateTeacher(
        teacher.id,
        ratingToSubmit.toInt(),
      );

      _lastSubmittedRating = ratingToSubmit;

      Get.snackbar('Success', message, backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    } finally {
      isSubmittingRating.value = false;
    }
  }
}
