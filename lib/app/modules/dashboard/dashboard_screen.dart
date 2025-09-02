import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../utils/helpers.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF008080), Colors.white],
            ),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(controller.user.value.name),
                  const SizedBox(height: 30),
                  const Text(
                    "Explore your learning journey",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildDashboardCard(
                    context,
                    icon: Icons.library_books,
                    title: 'All Subjects',
                    subtitle: 'Find and join your next course',
                    onTap: () {
                      Get.toNamed(Routes.SUBJECTS);
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.history_edu,
                    title: 'My Tests',
                    subtitle: 'Review your past test results',
                    onTap: () {
                      Get.toNamed(Routes.MY_TESTS);
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.star,
                    title: 'Favorites',
                    subtitle: 'See your favorite teachers & tests',
                    onTap: () {
                      Get.toNamed(Routes.FAVORITES);
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.emoji_events_outlined,
                    title: 'Challenges',
                    subtitle: 'Compete and test your knowledge',
                    onTap: () {
                      Get.toNamed(Routes.CHALLENGES);
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back,", style: TextStyle(fontSize: 16)),
            Text(
              "$userName!",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 32),
              onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
            ),
            Obx(
              () => controller.unreadNotifications.value > 0
                  ? Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          controller.unreadNotifications.value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        leading: Icon(icon, size: 40, color: primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
