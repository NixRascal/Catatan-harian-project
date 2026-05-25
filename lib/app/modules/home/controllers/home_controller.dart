import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../data/journal_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/google_auth_service.dart';
import '../../../services/quote_service.dart';

class HomeController extends GetxController {
  HomeController({JournalRepository? repository})
      : repository = repository ?? JournalRepository();

  final JournalRepository repository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final searchC = TextEditingController();

  final RxString selectedFilter = 'Semua'.obs;
  final RxString searchQuery = ''.obs;
  final RxString dailyQuote = '\u{1F31F} Simpan perasaan dan momenmu hari ini'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    final result = await QuoteService.fetchQuoteOfTheDay();
    final quote = result['quote'] ?? '';
    final author = result['author'] ?? '';
    if (quote.isNotEmpty) {
      dailyQuote.value = author.isNotEmpty
          ? '“$quote” — $author'
          : '“$quote”';
    }
  }

  static const filters = ['Semua', 'Terbaru', 'Favorit', 'Emoji'];

  String get userName {
    final user = auth.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) return displayName;
    return user?.email?.split('@').first ?? 'Bayu';
  }

  String? get photoUrl => auth.currentUser?.photoURL;

  Stream<List<JournalEntry>> watchEntries() => repository.watchEntries();

  List<JournalEntry> visibleEntries(List<JournalEntry> entries) {
    Iterable<JournalEntry> result = entries;
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((entry) {
        return entry.title.toLowerCase().contains(query) ||
            entry.content.toLowerCase().contains(query) ||
            entry.category.toLowerCase().contains(query) ||
            entry.moodLabel.toLowerCase().contains(query);
      });
    }

    switch (selectedFilter.value) {
      case 'Terbaru':
        final cutoff = DateTime.now().subtract(const Duration(days: 7));
        result = result.where((entry) => entry.createdAt.isAfter(cutoff));
      case 'Favorit':
        result = result.where((entry) => entry.isFavorite);
      case 'Emoji':
        final sorted = result.toList()
          ..sort((a, b) {
            final moodCompare = a.moodLabel.compareTo(b.moodLabel);
            if (moodCompare != 0) return moodCompare;
            return b.createdAt.compareTo(a.createdAt);
          });
        return sorted;
    }

    return result.toList();
  }

  Future<void> toggleFavorite(JournalEntry entry) async {
    await repository.toggleFavorite(entry);
  }

  void confirmDelete(JournalEntry entry) {
    Get.defaultDialog(
      title: 'Hapus catatan',
      middleText: 'Catatan ini akan dihapus permanen.',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await repository.delete(entry.id);
        Get.back();
      },
    );
  }

  Future<void> logout() async {
    await GoogleAuthService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void openProfile() => Get.toNamed(Routes.PROFILE);

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
