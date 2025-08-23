import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../utils/helpers.dart';

class CommentUser {
  final String name;
  final String? imageUrl;
  const CommentUser({required this.name, this.imageUrl});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(name: json['name'], imageUrl: json['user_image']);
  }
}

class Comment {
  final int id;
  final String content;
  final CommentUser user;
  final String createdAt;
  final RxList<Comment> replies = <Comment>[].obs;
  var isLoadingReplies = false.obs;

  Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      user: CommentUser.fromJson(json['user']),
      createdAt: formatRelativeTime(json['created_at']),
    );
  }
}
