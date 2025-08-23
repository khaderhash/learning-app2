import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../data/providers/favorites_provider.dart';

class FavoriteTestsController extends GetxController {
  final FavoritesProvider _provider = FavoritesProvider();

  final int teacherId = Get.arguments['teacherId'];
  final String teacherName = Get.arguments['teacherName'];

  var isLoading = true.obs;
  var favoriteTestsList = <TestSession>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteTests();
  }

  Future<void> fetchFavoriteTests() async {
    try {
      isLoading.value = true;
      final tests = await _provider.getFavoriteTests(teacherId);
      favoriteTestsList.assignAll(tests);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
