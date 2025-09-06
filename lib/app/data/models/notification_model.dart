import 'package:get/get.dart';

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
    String body = data['message'] ?? 'You have a new update.';

    if (data.containsKey('challenge_title')) {
      title = 'New Challenge: ${data['challenge_title']}';
      body =
          data['message'] ??
          'A new challenge has been added by ${data['teacher_name']}.';
    } else if (data.containsKey('commenter_name') &&
        data.containsKey('lesson_title')) {
      title = 'New Comment on "${data['lesson_title']}"';
      body = '${data['commenter_name']}: "${data['comment_content']}"';
    } else if (data.containsKey('student_name') &&
        data.containsKey('subject_title')) {
      title = 'New Subscription Request';
      body =
          '${data['student_name']} wants to join your subject: "${data['subject_title']}".';
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
