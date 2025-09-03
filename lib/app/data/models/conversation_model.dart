import './user_model.dart';

class Conversation {
  final int conversationId;
  final UserModel otherUser;
  final int unreadCount;

  Conversation({
    required this.conversationId,
    required this.otherUser,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversation_id'],
      otherUser: UserModel.fromJson(json['user']),
      unreadCount: json['unread_count'],
    );
  }
}
