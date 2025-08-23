import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../data/providers/subject_provider.dart';

class SubjectsController extends GetxController {
  final SubjectProvider _subjectProvider = SubjectProvider();

  var isLoading = true.obs;
  var subjectList = <Subject>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    try {
      isLoading.value = true;
      final subjects = await _subjectProvider.getSubjects();
      subjectList.assignAll(subjects);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not load subjects: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
