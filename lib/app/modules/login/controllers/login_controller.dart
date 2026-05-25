import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/google_auth_service.dart';

class LoginController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  Future<void> login() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Email dan kata sandi wajib diisi.');
      return;
    }

    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Terjadi kesalahan saat login.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      await GoogleAuthService.signIn();
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Google Sign-In gagal.');
    } catch (_) {
      _showError('Google Sign-In gagal. Periksa konfigurasi Firebase/OAuth.');
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void _showError(String message) {
    Get.defaultDialog(
      title: 'Login gagal',
      middleText: message,
      textConfirm: 'OK',
      onConfirm: Get.back,
    );
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
