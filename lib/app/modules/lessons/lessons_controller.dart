import 'package:get/get.dart';
import '../../data/models/lesson_model.dart';
import '../../data/providers/lesson_provider.dart';

class LessonsController extends GetxController {
  final LessonProvider _lessonProvider = LessonProvider();

  final int teacherId = Get.arguments['teacherId'];
  final String teacherName = Get.arguments['teacherName'];
  final int subjectId = Get.arguments['subjectId'];
  final String subjectTitle = Get.arguments['subjectTitle'];

  var isLoading = true.obs;
  var lessonList = <Lesson>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLessons();
  }

  Future<void> fetchLessons() async {
    try {
      isLoading.value = true;
      final lessons = await _lessonProvider.getLessons(teacherId, subjectId);
      lessonList.assignAll(lessons);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
