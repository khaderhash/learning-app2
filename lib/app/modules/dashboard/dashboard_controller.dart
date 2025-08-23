import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/profile_provider.dart';

class DashboardController extends GetxController {
  final ProfileProvider _profileProvider = ProfileProvider();

  var isLoading = true.obs;
  var user = UserModel(id: 0, name: 'Guest', email: '', phone: '').obs;

  @override
  void onReady() {
    super.onReady();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final userData = await _profileProvider.getUserProfile();
      user.value = userData;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not load user data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
