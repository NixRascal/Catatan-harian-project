import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_mood.dart';
import '../../../data/journal_repository.dart';

class CreateJournalController extends GetxController {
  CreateJournalController({JournalRepository? repository})
      : repository = repository ?? JournalRepository();

  final JournalRepository repository;

  final titleC = TextEditingController();
  final contentC = TextEditingController();

  static const categories = [
    'Personal',
    'Work',
    'Study',
    'Family',
    'Health',
    'Idea',
  ];

  static const colors = [
    'paper',
    'peach',
    'rose',
    'mint',
    'lavender',
    'sky',
    'yellow',
  ];

  final RxString selectedMood = JournalMoods.calm.emoji.obs;
  final RxString selectedCategory = categories.first.obs;
  final RxString selectedColor = colors.first.obs;
  final RxBool isLoading = false.obs;

  JournalMood get selectedMoodOption => JournalMoods.byEmoji(selectedMood.value);

  Future<void> addJournal() async {
    final title = titleC.text.trim();
    final content = contentC.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showError('Judul dan isi catatan wajib diisi.');
      return;
    }

    isLoading.value = true;
    try {
      final mood = selectedMoodOption;
      await repository.add(
        title: title,
        content: content,
        mood: mood.emoji,
        moodLabel: mood.label,
        category: selectedCategory.value,
        colorTint: selectedColor.value,
      );
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Catatan berhasil ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      _showError('Gagal menambahkan catatan.');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.defaultDialog(
      title: 'Tidak bisa menyimpan',
      middleText: message,
      textConfirm: 'OK',
      onConfirm: Get.back,
    );
  }

  @override
  void onClose() {
    titleC.dispose();
    contentC.dispose();
    super.onClose();
  }
}
