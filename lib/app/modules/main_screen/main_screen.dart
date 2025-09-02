import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/helpers.dart';
import '../dashboard/dashboard_screen.dart';
import '../my_tests/my_tests_screen.dart';
import '../profile/profile_screen.dart';
import 'main_screen_controller.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [DashboardScreen(), ProfileScreen()];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: screens),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home, color: primaryColor),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.person, color: primaryColor),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
