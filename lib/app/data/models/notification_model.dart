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
    final type = json['type'] as String;

    String title = 'New Notification';
    String body = data['message'] ?? 'You have received a new update.';
    if (type.contains('TeacherRequestStatusNotification')) {
      final status = data['status'] ?? 'updated';
      final subjectName = data['subject_name'] ?? 'a subject';

      if (status == 'accepted') {
        title = 'Subscription Approved!';
        body = 'Your request to join "$subjectName" has been approved.';
      } else {
        title = 'Subscription Update';
        body = 'Your request to join "$subjectName" has been rejected.';
      }
    } else if (type.contains('CommentNotification')) {
      title = 'New Comment on "${data['lesson_title']}"';
      body = '${data['user_name']}: "${data['comment']}"';
    } else if (type.contains('NewChallengeNotification')) {
      title = 'New Challenge: ${data['challenge_title']}';
      body = 'A new challenge has been added by ${data['teacher_name']}.';
    } else if (type.contains('StudentSubjectRequestNotification')) {
      title = 'New Subscription Request';
      body =
          data['message'] ??
          '${data['student_name']} wants to join your subject: "${data['subject_name']}".';
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
