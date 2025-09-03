import './user_model.dart';

class Teacher {
  final int id;
  final String name;
  final String? profileImageUrl;

  Teacher({required this.id, required this.name, this.profileImageUrl});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      profileImageUrl: json['user_image'],
    );
  }

  UserModel toUserModel() {
    return UserModel(
      id: id,
      name: name,
      imageUrl: profileImageUrl,
      email: '',
      phone: '',
    );
  }
}
