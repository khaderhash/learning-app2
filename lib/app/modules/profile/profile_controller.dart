import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/profile_provider.dart';
import '../../services/storage_service.dart';
import '../../routes/app_pages.dart';
import '../dashboard/dashboard_controller.dart';

class ProfileController extends GetxController {
  final ProfileProvider _profileProvider = ProfileProvider();
  final StorageService _storageService = Get.find<StorageService>();
  final ImagePicker _picker = ImagePicker();
  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  var isLoading = false.obs;
  late Rx<UserModel> user;
  var userr = UserModel(id: 0, name: 'Guest', email: '', phone: '').obs;

  @override
  void onInit() {
    super.onInit();
    user = _dashboardController.user;
  }

  Future<void> uploadProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        isLoading.value = true;
        final newImageUrl = await _profileProvider.updateUserImage(
          File(image.path),
        );

        user.update((val) {
          val = UserModel(
            id: val!.id,
            name: val.name,
            email: val.email,
            phone: val.phone,
            imageUrl: newImageUrl,
          );
        });

        Get.snackbar('Success', 'Profile image updated!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final message = await _profileProvider.changePassword(
        oldPassword,
        newPassword,
      );
      Get.back();
      Get.snackbar('Success', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void logout() async {
    await _storageService.deleteToken();
    Get.offAllNamed(Routes.LOGIN);
  }
}
