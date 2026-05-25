import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/google_auth_service.dart';

class RegisterController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  Future<void> register() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Semua field wajib diisi.');
      return;
    }
    if (password.length < 6) {
      _showError('Kata sandi minimal 6 karakter.');
      return;
    }

    isLoading.value = true;
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Pendaftaran gagal.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerWithGoogle() async {
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

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  void _showError(String message) {
    Get.defaultDialog(
      title: 'Daftar gagal',
      middleText: message,
      textConfirm: 'OK',
      onConfirm: Get.back,
    );
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
