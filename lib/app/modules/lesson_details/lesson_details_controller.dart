import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/providers/comment_provider.dart';

class LessonDetailsController extends GetxController {
  final CommentProvider _commentProvider = CommentProvider();

  final Lesson lesson = Get.arguments['lesson'];

  var isLoading = false.obs;
  var commentList = <Comment>[].obs;
  var isPostingComment = false.obs;
  int? replyingToCommentId;

  final commentTextController = TextEditingController();
  final commentFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      final comments = await _commentProvider.getComments(lesson.id);
      commentList.assignAll(comments);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postComment() async {
    final content = commentTextController.text.trim();
    if (content.isEmpty) return;

    try {
      isPostingComment.value = true;
      await _commentProvider.addComment(
        lessonId: lesson.id,
        content: content,
        parentId: replyingToCommentId,
      );
      commentTextController.clear();
      commentFocusNode.unfocus();
      replyingToCommentId = null;
      update();
      await fetchComments();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isPostingComment.value = false;
    }
  }

  Future<void> fetchReplies(Comment comment) async {
    try {
      comment.isLoadingReplies.value = true;
      final replies = await _commentProvider.getReplies(comment.id);
      comment.replies.assignAll(replies);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      comment.isLoadingReplies.value = false;
    }
  }

  void startReplying(int commentId) {
    replyingToCommentId = commentId;
    commentFocusNode.requestFocus();
    update();
  }

  void cancelReplying() {
    replyingToCommentId = null;
    commentFocusNode.unfocus();
    update();
  }

  @override
  void onClose() {
    commentTextController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }
}
