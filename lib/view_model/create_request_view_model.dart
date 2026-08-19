import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';

class CreateRequestViewModel extends ChangeNotifier {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  LatLng? selectedLocation;
  File? selectedImage;

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // --- Field setters ---
  void setCategory(String value) {
    categoryController.text = value;
    notifyListeners();
  }

  void setSubCategory(String value) {
    subCategoryController.text = value;
    notifyListeners();
  }

  void setDescription(String value) {
    descriptionController.text = value;
    notifyListeners();
  }

  void setAmount(String value) {
    amountController.text = value;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void setSelectedLocation(LatLng location) {
    selectedLocation = location;
    notifyListeners();
  }

  // --- Image Picker ---
  Future<void> pickCameraImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      selectedImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickGalleryImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      notifyListeners();
    }
  }

  void clearImage() {
    selectedImage = null;
    notifyListeners();
  }

  String? validateForm() {
    if (categoryController.text.isEmpty) {
      return 'Please select a category.';
    }
    if (subCategoryController.text.isEmpty) {
      return 'Please select a subcategory.';
    }
    if (descriptionController.text.isEmpty) {
      return 'Please enter a description.';
    }
    if (amountController.text.isEmpty) {
      return 'Please enter an amount.';
    }
    if (selectedDate == null) {
      return 'Please select a date.';
    }
    if (selectedTime == null) {
      return 'Please select a time.';
    }
    // Location validation is disabled for now
    // if (selectedLocation == null) {
    //   return 'Please select a location.';
    // }
    if (selectedImage == null) {
      return 'Please add an image.';
    }

    return null; // No errors
  }


  Future<String?> submitRequest() async {
    final error = validateForm();
    if (error != null) return error;

    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // simulate network/API call
      return null; // success
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    categoryController.dispose();
    subCategoryController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }
}

