import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  String initialRoute;
  try {
    final token = await storageService.getToken();
    if (token != null && token.isNotEmpty) {
      initialRoute = AppPages.INITIAL_AUTHENTICATED;
    } else {
      initialRoute = AppPages.INITIAL_UNAUTHENTICATED;
    }
  } catch (e) {
    print("Error reading token, defaulting to login: $e");
    initialRoute = AppPages.INITIAL_UNAUTHENTICATED;
  }

  Get.put(storageService);
  Get.put(AuthService());

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Student App",
      debugShowCheckedModeBanner: false,

      initialRoute: initialRoute,

      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Color(0xff29a4d9)),
            backgroundColor: const Color(0xff29a4d9),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
