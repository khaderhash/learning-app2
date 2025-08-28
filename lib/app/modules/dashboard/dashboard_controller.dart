import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/providers/profile_provider.dart';

class DashboardController extends GetxController {
  final ProfileProvider _profileProvider = ProfileProvider();
  final NotificationProvider _notificationProvider = NotificationProvider();

  var isLoading = true.obs;
  var user = UserModel(id: 0, name: 'Guest', email: '', phone: '').obs;
  var unreadNotifications = 0.obs;

  @override
  void onReady() {
    super.onReady();
    fetchUserProfile();
    fetchUnreadCount();
  }

  void incrementUnreadCount() {
    unreadNotifications.value++;
  }

  void decrementUnreadCount() {
    if (unreadNotifications.value > 0) {
      unreadNotifications.value--;
    }
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

  Future<void> fetchUnreadCount() async {
    try {
      unreadNotifications.value = await _notificationProvider.getUnreadCount();
    } catch (e) {
      print("Failed to get unread count: $e");
    }
  }
}
