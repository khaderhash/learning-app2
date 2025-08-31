import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app2/app/modules/auth/widget/CustomTextField.dart';
import 'auth_controller.dart';
import 'signup_screen.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Login',
          style: TextStyle(
            color: Color(0xff8B5CF6),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        const value2 = 0xff8B5CF6;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: controller.loginPhoneController,
                label: 'Phone Number',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.loginPasswordController,
                label: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8B5CF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.loginUser,
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () => Get.to(() => const SignUpScreen()),
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Color(value2)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff8B5CF6), width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26, width: 1.2),
        ),
      ),
    );
  }
}
