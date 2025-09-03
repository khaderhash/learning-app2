import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/chat_provider.dart';
import '../auth/auth_controller.dart';
import '../conversations/conversations_controller.dart';

class ChatController extends GetxController {
  final ChatProvider _provider = ChatProvider();

  final int conversationId = Get.arguments['conversationId'];
  final UserModel otherUser = Get.arguments['otherUser'];
  var isLoading = true.obs;
  var isSending = false.obs;
  var messageList = <Message>[].obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  int? currentUserId;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final response = await _provider.getMessagesWithUserId(conversationId);
      currentUserId = response['userId'];
      messageList.assignAll(response['messages']);
      _scrollToBottom();
    } catch (e) {
      Get.snackbar('Error', 'Could not load messages: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    try {
      isSending.value = true;
      textController.clear();
      await _provider.sendMessage(conversationId, text);
      if (Get.isRegistered<ConversationsController>()) {
        Get.find<ConversationsController>().fetchConversations();
      }

      await fetchMessages();
    } catch (e) {
      Get.snackbar('Error', 'Could not send message');
      textController.text = text;
    } finally {
      isSending.value = false;
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
