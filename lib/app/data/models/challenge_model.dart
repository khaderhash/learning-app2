class Challenge {
  final int id;
  final String title;
  final int teacherId;
  final DateTime startTime;
  final int durationMinutes;
  // final String teacherName;

  Challenge({
    required this.id,
    required this.title,
    required this.teacherId,
    required this.startTime,
    required this.durationMinutes,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      teacherId: json['teacher_id'],
      startTime: DateTime.parse(json['start_time']),
      durationMinutes: json['duration_minutes'],
    );
  }
}
