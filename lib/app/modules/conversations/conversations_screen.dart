import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app2/app/utils/helpers.dart';
import '../../data/models/conversation_model.dart';
import '../../routes/app_pages.dart';
import 'conversations_controller.dart';

class ConversationsScreen extends GetView<ConversationsController> {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF008080);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Conversations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        if (controller.conversationList.isEmpty) {
          return const Center(
            child: Text(
              'You have no conversations yet.\nStart a chat from a teacher\'s profile.',
              textAlign: TextAlign.center,
              style: TextStyle(color: primaryColor, fontSize: 14),
            ),
          );
        }
        return RefreshIndicator(
          color: primaryColor,
          onRefresh: controller.fetchConversations,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.conversationList.length,
            itemBuilder: (context, index) {
              final conversation = controller.conversationList[index];
              return _buildConversationTile(conversation, primaryColor);
            },
          ),
        );
      }),
    );
  }

  Widget _buildConversationTile(Conversation conversation, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: primaryColor.withOpacity(0.2),
          backgroundImage: conversation.otherUser.imageUrl != null
              ? NetworkImage(conversation.otherUser.imageUrl!)
              : null,
          child: conversation.otherUser.imageUrl == null
              ? Text(
                  conversation.otherUser.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          conversation.otherUser.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          'Tap to view chat',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: conversation.unreadCount > 0
            ? CircleAvatar(
                radius: 12,
                backgroundColor: primaryColor,
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : null,
        onTap: () {
          Get.toNamed(
            Routes.CHAT,
            arguments: {
              'conversationId': conversation.conversationId,
              'otherUser': conversation.otherUser,
            },
          );
        },
      ),
    );
  }
}
