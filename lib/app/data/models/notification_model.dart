import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final RxBool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required bool isRead,
  }) : isRead = isRead.obs;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    String title = 'New Notification';
    String body = data['message'] ?? 'You have a new notification.';

    if (data.containsKey('challenge_title')) {
      title = 'New Challenge Added!';
      body =
          data['message'] ??
          'Teacher ${data['teacher_name']} created a new challenge: "${data['challenge_title']}"';
    } else if (data.containsKey('student_name') &&
        data.containsKey('subject_title')) {
      title = 'New Subscription Request';
      body =
          'Student ${data['student_name']} requested to join the subject "${data['subject_title']}".';
    }

    return NotificationModel(
      id: json['id'],
      title: title,
      body: body,
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['read_at'] != null,
    );
  }
}
