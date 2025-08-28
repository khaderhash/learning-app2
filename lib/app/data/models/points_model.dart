class PointsRecord {
  final int id;
  final int teacherId;
  final String teacherName;
  final int points;
  final String? reason;

  PointsRecord({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.points,
    this.reason,
  });

  factory PointsRecord.fromJson(Map<String, dynamic> json) {
    return PointsRecord(
      id: json['id'],
      teacherId: json['teacher_id'],
      teacherName: json['teacher']?['name'] ?? 'Unknown Teacher',
      points: json['points'],
      reason: json['reason'],
    );
  }
}
