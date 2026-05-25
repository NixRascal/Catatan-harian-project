import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../data/journal_mood.dart';
import '../../../data/journal_repository.dart';

class MoodController extends GetxController {
  MoodController({JournalRepository? repository})
      : repository = repository ?? JournalRepository();

  final JournalRepository repository;
  final RxString selectedRange = 'Minggu ini'.obs;

  static const ranges = ['Minggu ini', 'Bulan ini', 'Semua'];

  Stream<List<JournalEntry>> watchEntries() => repository.watchEntries();

  List<JournalEntry> entriesForRange(List<JournalEntry> entries) {
    final now = DateTime.now();
    return entries.where((entry) {
      switch (selectedRange.value) {
        case 'Minggu ini':
          return entry.createdAt
              .isAfter(now.subtract(const Duration(days: 7)));
        case 'Bulan ini':
          return entry.createdAt.year == now.year &&
              entry.createdAt.month == now.month;
        default:
          return true;
      }
    }).toList();
  }

  Map<JournalMood, int> moodCounts(List<JournalEntry> entries) {
    final counts = <JournalMood, int>{};
    for (final mood in JournalMoods.all) {
      counts[mood] = 0;
    }
    for (final entry in entries) {
      final mood = JournalMoods.byEmoji(entry.mood);
      counts[mood] = (counts[mood] ?? 0) + 1;
    }
    return counts;
  }

  JournalMood topMood(List<JournalEntry> entries) {
    final counts = moodCounts(entries).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (counts.isEmpty || counts.first.value == 0) return JournalMoods.calm;
    return counts.first.key;
  }
}
