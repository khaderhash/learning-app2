import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final StorageService _storageService = StorageService();

  late TextEditingController nameController,
      emailController,
      passwordController,
      phoneController,
      loginPhoneController,
      loginPasswordController;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    loginPhoneController = TextEditingController();
    loginPasswordController = TextEditingController();
  }

  Future<void> signUpUser() async {
    try {
      isLoading.value = true;
      final response = await _authProvider.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phoneController.text,
      );
      final token = response['token'] as String?;
      if (token != null) {
        await _storageService.saveToken(token);
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.snackbar(
          'Error',
          'Token not found.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser() async {
    try {
      isLoading.value = true;
      final response = await _authProvider.login(
        phone: loginPhoneController.text,
        password: loginPasswordController.text,
      );
      final token = response['token'] as String?;
      if (token != null) {
        await _storageService.saveToken(token);
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.snackbar(
          'Error',
          'Token not found.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login Failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    loginPhoneController.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }
}
