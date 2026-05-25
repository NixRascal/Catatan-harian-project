import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../data/journal_mood.dart';
import '../../../data/journal_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/google_auth_service.dart';

class ProfileController extends GetxController {
  ProfileController({JournalRepository? repository})
      : repository = repository ?? JournalRepository();

  final JournalRepository repository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final nameC = TextEditingController();
  final RxBool isSavingName = false.obs;
  final RxBool isDeletingAccount = false.obs;

  User? get user => auth.currentUser;
  String get displayName {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return user?.email?.split('@').first ?? 'Bayu';
  }

  String get email => user?.email ?? 'bayu.journal@serene.co';
  String? get photoUrl => user?.photoURL;

  @override
  void onInit() {
    super.onInit();
    nameC.text = displayName;
  }

  Stream<List<JournalEntry>> watchEntries() => repository.watchEntries();

  int streak(List<JournalEntry> entries) {
    final days = entries
        .map((entry) => DateTime(
              entry.createdAt.year,
              entry.createdAt.month,
              entry.createdAt.day,
            ))
        .toSet();
    var count = 0;
    var cursor = DateTime.now();
    while (days.contains(DateTime(cursor.year, cursor.month, cursor.day))) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }

  JournalMood favoriteMood(List<JournalEntry> entries) {
    final counts = <String, int>{};
    for (final entry in entries) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }
    if (counts.isEmpty) return JournalMoods.calm;
    final top = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return JournalMoods.byEmoji(top.first.key);
  }

  String memberSince() {
    final created = user?.metadata.creationTime;
    if (created == null) return 'Member since today';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Member since ${months[created.month - 1]} ${created.year}';
  }

  Future<void> updateName() async {
    final name = nameC.text.trim();
    if (name.isEmpty) return;
    isSavingName.value = true;
    try {
      await user?.updateDisplayName(name);
      await user?.reload();
      Get.back();
      Get.snackbar('Berhasil', 'Nama profil diperbarui.');
      update();
    } finally {
      isSavingName.value = false;
    }
  }

  Future<void> logout() async {
    await GoogleAuthService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void confirmDeleteAccount() {
    Get.defaultDialog(
      title: 'Hapus akun',
      middleText:
          'Semua catatan dan akunmu akan dihapus. Tindakan ini tidak bisa dibatalkan.',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: deleteAccount,
    );
  }

  Future<void> deleteAccount() async {
    final currentUser = user;
    if (currentUser == null) return;
    isDeletingAccount.value = true;
    try {
      await repository.deleteAllForCurrentUser();
      await currentUser.delete();
      await GoogleAuthService.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.defaultDialog(
        title: 'Butuh login ulang',
        middleText: e.code == 'requires-recent-login'
            ? 'Silakan logout lalu login kembali sebelum menghapus akun.'
            : (e.message ?? 'Gagal menghapus akun.'),
        textConfirm: 'OK',
        onConfirm: Get.back,
      );
    } finally {
      isDeletingAccount.value = false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    super.onClose();
  }
}
