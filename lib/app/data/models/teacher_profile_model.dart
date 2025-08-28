import '../models/teacher_model.dart';

class TeacherProfile {
  final String? bio;
  final String? specialization;
  final String? age;

  TeacherProfile({this.bio, this.specialization, this.age});

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      bio: json['bio'] as String?,
      specialization: json['specialization'] as String?,
      age: json['age'] as String?,
    );
  }
}

class TeacherFullProfile {
  final Teacher baseInfo;
  final TeacherProfile? details;

  TeacherFullProfile({required this.baseInfo, this.details});
}
