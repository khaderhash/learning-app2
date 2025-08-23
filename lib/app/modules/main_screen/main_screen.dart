import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: screens),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color(0xff29a4d9)),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Color(0xff29a4d9)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
