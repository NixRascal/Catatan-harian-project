import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../data/journal_mood.dart';
import '../../../data/journal_repository.dart';
import '../../create_journal/controllers/create_journal_controller.dart';

class DetailJournalController extends GetxController {
  DetailJournalController({JournalRepository? repository})
      : repository = repository ?? JournalRepository();

  final JournalRepository repository;

  final titleC = TextEditingController();
  final contentC = TextEditingController();

  late final String docId;

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isEditMode = false.obs;
  final Rxn<JournalEntry> entry = Rxn<JournalEntry>();

  final RxString selectedMood = JournalMoods.calm.emoji.obs;
  final RxString selectedCategory =
      CreateJournalController.categories.first.obs;
  final RxString selectedColor = CreateJournalController.colors.first.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    docId = (args is Map && args['docId'] is String)
        ? args['docId'] as String
        : '';
    if (docId.isEmpty) {
      Get.back();
      return;
    }
    loadJournal();
  }

  Future<void> loadJournal() async {
    isLoading.value = true;
    try {
      final loaded = await repository.getById(docId);
      if (loaded == null) {
        Get.back();
        return;
      }
      _applyEntry(loaded);
    } catch (_) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Gagal memuat catatan.',
        textConfirm: 'OK',
        onConfirm: Get.back,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _applyEntry(JournalEntry value) {
    entry.value = value;
    titleC.text = value.title;
    contentC.text = value.content;
    selectedMood.value = value.mood;
    selectedCategory.value = value.category;
    selectedColor.value = value.colorTint;
  }

  JournalMood get selectedMoodOption => JournalMoods.byEmoji(selectedMood.value);

  void enterEditMode() => isEditMode.value = true;

  void cancelEdit() {
    final value = entry.value;
    if (value != null) _applyEntry(value);
    isEditMode.value = false;
  }

  Future<void> updateJournal() async {
    final current = entry.value;
    if (current == null) return;
    final title = titleC.text.trim();
    final content = contentC.text.trim();
    if (title.isEmpty || content.isEmpty) {
      Get.defaultDialog(
        title: 'Tidak bisa menyimpan',
        middleText: 'Judul dan isi catatan wajib diisi.',
        textConfirm: 'OK',
        onConfirm: Get.back,
      );
      return;
    }

    isSaving.value = true;
    try {
      final mood = selectedMoodOption;
      final updated = current.copyWith(
        title: title,
        content: content,
        mood: mood.emoji,
        moodLabel: mood.label,
        category: selectedCategory.value,
        colorTint: selectedColor.value,
      );
      await repository.update(updated);
      _applyEntry(updated);
      isEditMode.value = false;
      Get.snackbar(
        'Berhasil',
        'Catatan berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Gagal memperbarui catatan.',
        textConfirm: 'OK',
        onConfirm: Get.back,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    final current = entry.value;
    if (current == null) return;
    await repository.toggleFavorite(current);
    entry.value = current.copyWith(isFavorite: !current.isFavorite);
  }

  void deleteJournal() {
    final current = entry.value;
    if (current == null) return;
    Get.defaultDialog(
      title: 'Hapus catatan',
      middleText: 'Catatan ini akan dihapus permanen.',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await repository.delete(current.id);
        Get.back();
        Get.back();
      },
    );
  }

  @override
  void onClose() {
    titleC.dispose();
    contentC.dispose();
    super.onClose();
  }
}
