import 'package:get/get_utils/src/platform/platform.dart';

class Lesson {
  final int id;
  final String title;
  final String? videoUrl;
  final String? summaryUrl;

  Lesson({
    required this.id,
    required this.title,
    this.videoUrl,
    this.summaryUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    String? correctVideoUrl = json['video_path'];
    if (correctVideoUrl != null && GetPlatform.isAndroid) {
      correctVideoUrl = correctVideoUrl
          .replaceAll('127.0.0.1', '10.0.2.2')
          .replaceAll('localhost', '10.0.2.2');
    }

    String? correctSummaryUrl = json['summary_path'];
    if (correctSummaryUrl != null && GetPlatform.isAndroid) {
      correctSummaryUrl = correctSummaryUrl
          .replaceAll('127.0.0.1', '10.0.2.2')
          .replaceAll('localhost', '10.0.2.2');
    }

    return Lesson(
      id: json['id'],
      title: json['title'],
      videoUrl: correctVideoUrl,
      summaryUrl: correctSummaryUrl,
    );
  }
}
