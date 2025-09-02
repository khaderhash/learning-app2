import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app2/app/modules/auth/widget/CustomTextField.dart';
import '../../utils/helpers.dart';
import 'auth_controller.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Sign Up',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
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
                    backgroundColor: primaryColor,
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
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
