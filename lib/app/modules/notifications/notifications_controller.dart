import 'package:get/get.dart';
import '../../data/models/notification_model.dart';
import '../../data/providers/notification_provider.dart';
import '../../services/notification_service.dart';
import '../dashboard/dashboard_controller.dart';

class NotificationsController extends GetxController {
  final NotificationProvider _provider = NotificationProvider();

  var isLoading = true.obs;
  var notificationList = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final notifications = await _provider.getNotifications();
      notificationList.assignAll(notifications);

      if (notifications.isNotEmpty) {
        final latest = notifications.first;
        LocalNotificationService.showNotification(
          title: latest.title,
          body: latest.body,
        );
      }

      Get.find<DashboardController>().fetchUnreadCount();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(NotificationModel notification) async {
    if (notification.isRead.value) return;

    try {
      notification.isRead.value = true;

      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().decrementUnreadCount();
      }
      await _provider.markAsRead(notification.id);
    } catch (e) {
      notification.isRead.value = false;
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().incrementUnreadCount();
      }
      Get.snackbar('Error', "Failed to mark as read. Please try again.");
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _provider.markAllAsRead();
      await fetchNotifications();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
