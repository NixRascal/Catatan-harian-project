import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final emailC = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> sendPasswordReset() async {
    final email = emailC.text.trim();
    if (email.isEmpty) {
      _showError('Email wajib diisi.');
      return;
    }

    isLoading.value = true;
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.toNamed(Routes.OTP_RESET, arguments: {'email': email});
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Gagal mengirim email reset password.');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.defaultDialog(
      title: 'Reset gagal',
      middleText: message,
      textConfirm: 'OK',
      onConfirm: Get.back,
    );
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }
}
