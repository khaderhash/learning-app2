import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/helpers.dart';
import '../dashboard/dashboard_controller.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Profile',

          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (dashboardController.isLoading.value || controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        final user = controller.user.value;
        return RefreshIndicator(
          onRefresh: dashboardController.fetchUserProfile,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 60,
                      backgroundImage: user.imageUrl != null
                          ? NetworkImage(user.imageUrl!)
                          : null,
                      child: user.imageUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 60,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: controller.uploadProfileImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileInfoTile('Name', user.name),
              _buildProfileInfoTile('Email', user.email),
              _buildProfileInfoTile('Phone', user.phone),
              const Divider(height: 40),
              ListTile(
                leading: const Icon(Icons.reviews_outlined),
                title: const Text('Rate Your Teachers'),
                onTap: () {
                  // Get.toNamed(Routes.RATE_TEACHERS);
                  Get.snackbar(
                    'Coming Soon',
                    'This feature is under development.',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.defaultDialog(
                    title: "Confirm Logout",
                    titleStyle: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    middleText: "Are you sure you want to logout?",
                    middleTextStyle: const TextStyle(fontSize: 16),
                    textCancel: "Cancel",
                    cancelTextColor: Colors.black54,
                    textConfirm: "Logout",
                    confirmTextColor: Colors.white,
                    buttonColor: primaryColor,
                    radius: 12,
                    onConfirm: () {
                      Get.back();
                      controller.logout();
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileInfoTile(String title, String subtitle) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
