import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../data/journal_mood.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/mood_controller.dart';

class MoodView extends GetView<MoodController> {
  const MoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      currentTab: StitchTab.mood,
      child: StreamBuilder<List<JournalEntry>>(
        stream: controller.watchEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <JournalEntry>[];
          return Obx(() {
            final scoped = controller.entriesForRange(entries);
            final topMood = controller.topMood(scoped);
            final counts = controller.moodCounts(scoped);
            final maxCount = counts.values.fold<int>(0, (a, b) => a > b ? a : b);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
              children: [
                Text('Mood', style: AppTypography.headlineMd),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  '${topMood.emoji} Lihat suasana harimu akhir-akhir ini',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppSpacing.s16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: MoodController.ranges
                        .map(
                          (range) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: StitchPill(
                              label: range,
                              selected: controller.selectedRange.value == range,
                              onTap: () =>
                                  controller.selectedRange.value = range,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                _MoodSummary(mood: topMood, count: counts[topMood] ?? 0),
                const SizedBox(height: AppSpacing.s16),
                _Distribution(counts: counts, maxCount: maxCount),
                const SizedBox(height: AppSpacing.s24),
                Text('Catatan berdasarkan mood', style: AppTypography.titleMd),
                const SizedBox(height: AppSpacing.s12),
                if (scoped.isEmpty)
                  const _EmptyMood()
                else
                  ...scoped.take(8).map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _MoodEntryTile(entry: entry),
                        ),
                      ),
              ],
            );
          });
        },
      ),
    );
  }
}

class _MoodSummary extends StatelessWidget {
  const _MoodSummary({required this.mood, required this.count});

  final JournalMood mood;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.br8,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mood.color,
              shape: BoxShape.circle,
            ),
            child: Text(mood.emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RINGKASAN MOOD', style: AppTypography.caps),
                const SizedBox(height: AppSpacing.s8),
                Text(mood.label, style: AppTypography.headlineMd),
                const SizedBox(height: AppSpacing.s4),
                Text(mood.description, style: AppTypography.caption),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$count',
                style: AppTypography.serif(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('catatan', style: AppTypography.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _Distribution extends StatelessWidget {
  const _Distribution({required this.counts, required this.maxCount});

  final Map<JournalMood, int> counts;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.br8,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DISTRIBUSI EMOSI', style: AppTypography.caps),
          const SizedBox(height: AppSpacing.s16),
          ...counts.entries.where((entry) => entry.value > 0).map((entry) {
            final percent = maxCount == 0 ? 0.0 : entry.value / maxCount;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 82,
                    child: Text(
                      '${entry.key.emoji} ${entry.key.label}',
                      style: AppTypography.caption,
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: AppSpacing.br8,
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        value: percent,
                        backgroundColor: AppColors.surfaceLow,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s10),
                  Text('${entry.value}', style: AppTypography.caption),
                ],
              ),
            );
          }),
          if (maxCount == 0)
            Text('Belum ada mood untuk periode ini.', style: AppTypography.bodySm),
        ],
      ),
    );
  }
}

class _MoodEntryTile extends StatelessWidget {
  const _MoodEntryTile({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLowest,
      borderRadius: AppSpacing.br8,
      child: InkWell(
        onTap: () => Get.toNamed(
          Routes.DETAIL_JOURNAL,
          arguments: {'docId': entry.id},
        ),
        borderRadius: AppSpacing.br8,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppSpacing.br8,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              Text(entry.mood, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.displayTitle, style: AppTypography.titleSm),
                    const SizedBox(height: 3),
                    Text(
                      entry.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              Text(_shortDate(entry.createdAt), style: AppTypography.caption),
            ],
          ),
        ),
      ),
    );
  }

  String _shortDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

class _EmptyMood extends StatelessWidget {
  const _EmptyMood();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.br8,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        'Belum ada catatan di periode ini.',
        textAlign: TextAlign.center,
        style: AppTypography.bodySm,
      ),
    );
  }
}
