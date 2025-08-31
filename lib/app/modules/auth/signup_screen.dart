import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app2/app/modules/auth/widget/CustomTextField.dart';
import 'auth_controller.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Sign Up',
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
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: controller.nameController,
                label: 'Name',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.emailController,
                label: 'Email',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.passwordController,
                label: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.phoneController,
                label: 'Phone',
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
                  onPressed: controller.signUpUser,
                  child: const Text('Sign Up'),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Color(0xff8B5CF6)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
