import 'package:get/get.dart';
import '../../data/models/challenge_model.dart';
import '../../data/models/teacher_model.dart';
import '../../data/providers/challenge_provider.dart';
import '../../data/providers/teacher_provider.dart';

class ChallengesController extends GetxController {
  final ChallengeProvider _provider = ChallengeProvider();
  final TeacherProvider _teacherProvider = TeacherProvider();

  var isLoading = true.obs;
  var challengeList = <Challenge>[].obs;
  var teachersMap = <int, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChallenges();
    fetchData();
  }

  Future<void> fetchChallenges() async {
    try {
      isLoading.value = true;
      final challenges = await _provider.getChallenges();
      challengeList.assignAll(challenges);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _provider.getChallenges(),
        _teacherProvider.getAllTeachers(),
      ]);

      final challenges = results[0] as List<Challenge>;
      final teachers = results[1] as List<Teacher>;

      teachersMap.value = {
        for (var teacher in teachers) teacher.id: teacher.name,
      };

      challengeList.assignAll(challenges);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
