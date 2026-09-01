import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/res/app_url.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/services/api_service.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var profileModel = Rxn<ProfileModel>();

  // Text editing controllers for EditProfileScreen
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading(true);
    try {
      final response = await _apiService.getRequest(
        AppUrl.userProfile,
        requireAuth: true,
      );

      if (response['success'] == true) {
        var data = response['data'];
        if (data['user'] != null) {
            data = data['user'];
        }
        
        profileModel.value = ProfileModel.fromJson(data);
        
        // Update controllers
        nameController.text = profileModel.value?.name ?? '';
        emailController.text = profileModel.value?.email ?? '';
        phoneController.text = profileModel.value?.phone ?? '';
        addressController.text = data['address'] ?? ''; 
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to fetch profile");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching profile");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    isUpdating(true);
    try {
      final Map<String, dynamic> data = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
      };

      if (emailController.text.isNotEmpty) {
          data['email'] = emailController.text.trim();
      }

      final response = await _apiService.putRequest( // Assuming PUT request for update
        AppUrl.userProfile,
        data,
        requireAuth: true,
      );

      if (response['success'] == true) {
        Get.snackbar("Success", "Profile updated successfully!", 
          backgroundColor: Colors.green, colorText: Colors.white);
        
        await fetchProfile();
        Get.back();
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to update profile");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while updating profile");
    } finally {
      isUpdating(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
