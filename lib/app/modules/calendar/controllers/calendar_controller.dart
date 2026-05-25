import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../data/journal_repository.dart';

class CalendarController extends GetxController {
  CalendarController({JournalRepository? repository})
      : repository = repository ?? JournalRepository();

  final JournalRepository repository;
  final Rx<DateTime> currentMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  ).obs;
  final Rx<DateTime> selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;

  Stream<List<JournalEntry>> watchEntries() => repository.watchEntries();

  void previousMonth() {
    final current = currentMonth.value;
    currentMonth.value = DateTime(current.year, current.month - 1);
  }

  void nextMonth() {
    final current = currentMonth.value;
    currentMonth.value = DateTime(current.year, current.month + 1);
  }

  void selectDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  List<JournalEntry> entriesForSelectedDate(List<JournalEntry> entries) {
    return entries.where((entry) => isSameDay(entry.createdAt, selectedDate.value)).toList();
  }

  List<JournalEntry> entriesForDate(List<JournalEntry> entries, DateTime date) {
    return entries.where((entry) => isSameDay(entry.createdAt, date)).toList();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
