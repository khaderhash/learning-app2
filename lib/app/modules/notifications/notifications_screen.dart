import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Notifications'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: controller.markAllAsRead,
              icon: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.notificationList.isEmpty) {
          return const Center(child: Text('You have no notifications.'));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: ListView.builder(
            itemCount: controller.notificationList.length,
            itemBuilder: (context, index) {
              final notification = controller.notificationList[index];
              return Obx(
                () => ListTile(
                  tileColor: notification.isRead.value
                      ? Colors.transparent
                      : Colors.white,
                  leading: Icon(
                    notification.isRead.value
                        ? Icons.notifications_off_outlined
                        : Icons.notifications_active,
                    color: notification.isRead.value
                        ? Colors.grey
                        : Color(0xff8B5CF6),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead.value
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    DateFormat('MMM d').format(notification.createdAt),
                  ),
                  onTap: () {
                    controller.markAsRead(notification);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
