import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app2/app/modules/lesson_details/widget/lesson_video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/comment_model.dart';
import '../../routes/app_pages.dart';
import '../lesson_details/lesson_details_controller.dart';

class LessonDetailsScreen extends GetView<LessonDetailsController> {
  const LessonDetailsScreen({Key? key}) : super(key: key);

  Future<void> _launchUrl(String urlString) async {
    if (!await launchUrl(Uri.parse(urlString))) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          controller.lesson.title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.lesson.videoUrl != null &&
                        controller.lesson.videoUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LessonVideoPlayer(
                          videoUrl: controller.lesson.videoUrl!,
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Text('No video available')),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      controller.lesson.title,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  indicatorColor: Color(0xff8B5CF6),
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Summary (PDF)'),
                    Tab(text: 'Comments'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ],
          body: TabBarView(children: [_buildSummaryTab(), _buildCommentsTab()]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _showStartTestDialog(
            context,
            controller.lesson.id,
            controller.lesson.title,
          ),
          child: const Text('Start Test'),
        ),
      ),
    );
  }

  void _showStartTestDialog(
    BuildContext context,
    int lessonId,
    String lessonTitle,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text(lessonTitle),
        content: const Text('What would you like to do?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Browse Questions',
              style: TextStyle(color: Color(0xff8B5CF6)),
            ),
            onPressed: () {
              Get.back();
              Get.toNamed(
                Routes.BROWSE_QUESTIONS,
                arguments: {'lessonId': lessonId, 'lessonTitle': lessonTitle},
              );
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .33,
            child: ElevatedButton(
              child: const Text('Start Graded Test'),
              onPressed: () {
                Get.back();
                Get.toNamed(Routes.QUIZ, arguments: {'lessonId': lessonId});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    if (controller.lesson.summaryUrl != null &&
        controller.lesson.summaryUrl!.isNotEmpty) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Open Summary PDF'),
          onPressed: () => _launchUrl(controller.lesson.summaryUrl!),
        ),
      );
    } else {
      return const Center(child: Text('No summary available for this lesson.'));
    }
  }

  Widget _buildCommentsTab() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff8B5CF6)),
              );
            }
            if (controller.commentList.isEmpty) {
              return const Center(child: Text('Be the first to comment!'));
            }
            return RefreshIndicator(
              color: Color(0xff8B5CF6),
              onRefresh: controller.fetchComments,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: controller.commentList.length,
                itemBuilder: (_, index) =>
                    _buildCommentItem(controller.commentList[index]),
              ),
            );
          }),
        ),
        _buildCommentInputField(),
      ],
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<LessonDetailsController>(
        builder: (c) => Row(
          children: [
            Expanded(
              child: TextField(
                controller: c.commentTextController,
                focusNode: c.commentFocusNode,
                decoration: InputDecoration(
                  hintText: c.replyingToCommentId == null
                      ? 'Add a public comment...'
                      : 'Replying...',
                  hintStyle: TextStyle(color: Color(0xff8B5CF6)),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            Obx(
              () => IconButton(
                icon: c.isPostingComment.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xff8B5CF6),
                        ),
                      )
                    : const Icon(Icons.send),
                onPressed: c.postComment,
              ),
            ),
            if (c.replyingToCommentId != null)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: c.cancelReplying,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment, {bool isReply = false}) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(left: isReply ? 40.0 : 0, top: 8, right: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff8B5CF6),
                  child: Text(
                    comment.user.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  comment.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff8B5CF6),
                  ),
                ),
                const Spacer(),
                Text(comment.createdAt, style: Get.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.content),
            Row(
              children: [
                if (!isReply)
                  TextButton(
                    onPressed: () => controller.startReplying(comment.id),
                    child: const Text(
                      'Reply',
                      style: TextStyle(color: Color(0xff8B5CF6)),
                    ),
                  ),
                if (!isReply)
                  Obx(
                    () => TextButton(
                      onPressed: comment.isLoadingReplies.value
                          ? null
                          : () => controller.fetchReplies(comment),
                      child: comment.isLoadingReplies.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xff8B5CF6),
                              ),
                            )
                          : Text(
                              'View replies',
                              style: TextStyle(color: Color(0xff8B5CF8B5CF6)),
                            ),
                    ),
                  ),
              ],
            ),
            Obx(
              () => (comment.replies.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: comment.replies
                            .map(
                              (reply) =>
                                  _buildCommentItem(reply, isReply: true),
                            )
                            .toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
