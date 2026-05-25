import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../data/journal_mood.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../../create_journal/controllers/create_journal_controller.dart';
import '../controllers/detail_journal_controller.dart';

class DetailJournalView extends GetView<DetailJournalController> {
  const DetailJournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      resizeToAvoidBottomInset: true,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final entry = controller.entry.value;
        if (entry == null) return const SizedBox.shrink();
        return Column(
          children: [
            StitchTopBar(
              title: 'Journal',
              leadingIcon: Icons.arrow_back_rounded,
              onLeading: Get.back,
              trailing: controller.isEditMode.value
                  ? TextButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : controller.updateJournal,
                      child: Text(
                        controller.isSaving.value ? '...' : 'Save',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz_rounded),
                      onSelected: (value) {
                        if (value == 'edit') controller.enterEditMode();
                        if (value == 'favorite') controller.toggleFavorite();
                        if (value == 'delete') controller.deleteJournal();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'favorite',
                          child: Text(
                            entry.isFavorite
                                ? 'Hapus favorit'
                                : 'Jadikan favorit',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
            ),
            const Divider(height: 1, color: AppColors.outlineVariant),
            Expanded(
              child: controller.isEditMode.value
                  ? _EditBody(controller: controller)
                  : _ReadBody(entry: entry),
            ),
          ],
        );
      }),
    );
  }
}

class _ReadBody extends StatelessWidget {
  const _ReadBody({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
      children: [
        Row(
          children: [
            Text(_date(entry.createdAt), style: AppTypography.caps),
            const Spacer(),
            Text(entry.mood, style: const TextStyle(fontSize: 24)),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          entry.displayTitle,
          style: AppTypography.serif(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(entry.category)),
            Chip(label: Text(entry.moodLabel)),
            if (entry.isFavorite) const Chip(label: Text('Favorit')),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),
        SelectableText(
          entry.content,
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurface,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  String _date(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGU',
      'SEP',
      'OKT',
      'NOV',
      'DES',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _EditBody extends StatelessWidget {
  const _EditBody({required this.controller});

  final DetailJournalController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
      children: [
        TextField(
          controller: controller.titleC,
          cursorColor: AppColors.primary,
          maxLength: 100,
          buildCounter: _hideCounter,
          style: AppTypography.serif(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
          decoration: const InputDecoration(
            hintText: 'Title',
            border: InputBorder.none,
          ),
        ),
        TextField(
          controller: controller.contentC,
          cursorColor: AppColors.primary,
          maxLength: 10000,
          maxLines: null,
          minLines: 10,
          buildCounter: _hideCounter,
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurface,
            height: 1.65,
          ),
          decoration: const InputDecoration(
            hintText: "What's on your mind?",
            border: InputBorder.none,
          ),
        ),
        const Divider(color: AppColors.outlineVariant),
        const SizedBox(height: AppSpacing.s10),
        Text(
          'Mood',
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.s12),
        Obx(
          () => Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 12,
            children: JournalMoods.all.map((mood) {
              final selected = controller.selectedMood.value == mood.emoji;
              return GestureDetector(
                onTap: () => controller.selectedMood.value = mood.emoji,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    mood.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Obx(
          () => Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: CreateJournalController.categories.map((category) {
              return StitchPill(
                label: category,
                selected: controller.selectedCategory.value == category,
                onTap: () => controller.selectedCategory.value = category,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Center(
          child: TextButton(
            onPressed: controller.cancelEdit,
            child: const Text('Batal edit'),
          ),
        ),
      ],
    );
  }

  static Widget? _hideCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) =>
      null;
}
