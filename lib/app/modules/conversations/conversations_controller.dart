import 'package:get/get.dart';
import '../../data/models/conversation_model.dart';
import '../../data/providers/chat_provider.dart';

class ConversationsController extends GetxController {
  final ChatProvider _provider = ChatProvider();

  var isLoading = false.obs;
  var conversationList = <Conversation>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      if (conversationList.isEmpty) {
        isLoading.value = true;
      }
      final conversations = await _provider.getMyConversations();
      conversationList.assignAll(conversations);
    } catch (e) {
      print("error : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
