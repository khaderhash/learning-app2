import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import '../../data/providers/favorites_provider.dart';

class FavoritesController extends GetxController {
  final FavoritesProvider _provider = FavoritesProvider();

  var isLoading = true.obs;
  var favoriteTeachersList = <Teacher>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteTeachers();
  }

  Future<void> fetchFavoriteTeachers() async {
    try {
      isLoading.value = true;
      final teachers = await _provider.getFavoriteTeachers();
      favoriteTeachersList.assignAll(teachers);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
