import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      currentTab: StitchTab.calendar,
      child: StreamBuilder<List<JournalEntry>>(
        stream: controller.watchEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <JournalEntry>[];
          return Obx(
            () => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                _MonthHeader(
                  month: controller.currentMonth.value,
                  onPrevious: controller.previousMonth,
                  onNext: controller.nextMonth,
                ),
                const SizedBox(height: AppSpacing.s16),
                _CalendarGrid(controller: controller, entries: entries),
                const SizedBox(height: AppSpacing.s24),
                Text(
                  'Catatan ${_selectedDateLabel(controller.selectedDate.value)}',
                  style: AppTypography.titleMd,
                ),
                const SizedBox(height: AppSpacing.s12),
                ..._selectedEntries(entries).map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CalendarEntry(entry: entry),
                  ),
                ),
                if (_selectedEntries(entries).isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest,
                      borderRadius: AppSpacing.br8,
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Text(
                      'Belum ada catatan pada tanggal ini.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySm,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<JournalEntry> _selectedEntries(List<JournalEntry> entries) {
    return controller.entriesForSelectedDate(entries);
  }

  String _selectedDateLabel(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: onPrevious,
        ),
        Expanded(
          child: Text(
            '${months[month.month - 1]} ${month.year}',
            textAlign: TextAlign.center,
            style: AppTypography.titleMd.copyWith(color: AppColors.primary),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.controller, required this.entries});

  final CalendarController controller;
  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    final month = controller.currentMonth.value;
    final first = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final offset = first.weekday - 1;
    final cells = List<DateTime?>.filled(offset, null, growable: true)
      ..addAll(
        List.generate(
          daysInMonth,
          (index) => DateTime(month.year, month.month, index + 1),
        ),
      );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.br12,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(day, style: AppTypography.caption),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.s10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final date = cells[index];
              if (date == null) return const SizedBox.shrink();
              final dayEntries = controller.entriesForDate(entries, date);
              final selected =
                  controller.isSameDay(date, controller.selectedDate.value);
              return GestureDetector(
                onTap: () => controller.selectDate(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    borderRadius: AppSpacing.br8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: AppTypography.caption.copyWith(
                          color: selected
                              ? AppColors.primaryOn
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        height: 16,
                        child: dayEntries.isEmpty
                            ? const SizedBox.shrink()
                            : Text(
                                dayEntries.first.mood,
                                style: const TextStyle(fontSize: 12),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarEntry extends StatelessWidget {
  const _CalendarEntry({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLowest,
      borderRadius: AppSpacing.br8,
      child: InkWell(
        borderRadius: AppSpacing.br8,
        onTap: () => Get.toNamed(
          Routes.DETAIL_JOURNAL,
          arguments: {'docId': entry.id},
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: AppSpacing.br8,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.mood, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.displayTitle, style: AppTypography.titleSm),
                    const SizedBox(height: AppSpacing.s6),
                    Text(
                      entry.preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Chip(label: Text(entry.category)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
