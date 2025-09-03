import 'package:get/get.dart';
import '../../data/providers/test_history_provider.dart';
import '../../data/models/points_model.dart';
import '../../data/providers/points_provider.dart';

class QuizResultController extends GetxController {
  final TestHistoryProvider _testHistoryProvider = TestHistoryProvider();
  final PointsProvider _pointsProvider = PointsProvider();

  final int testId = Get.arguments['testId'];

  var isLoading = true.obs;
  var result = <String, int>{}.obs;
  var points = <PointsRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchResultAndPoints();
  }

  Future<void> fetchResultAndPoints() async {
    try {
      isLoading.value = true;
      final responses = await Future.wait([
        _testHistoryProvider.getTestResult(testId),
        _pointsProvider.getStudentPoints(),
      ]);
      result.value = responses[0] as Map<String, int>;
      points.value = responses[1] as List<PointsRecord>;
    } catch (e) {
      Get.snackbar('Error', 'Could not load result details: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
