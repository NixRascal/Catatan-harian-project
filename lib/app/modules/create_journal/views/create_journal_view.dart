import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_mood.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/create_journal_controller.dart';

class CreateJournalView extends GetView<CreateJournalController> {
  const CreateJournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      resizeToAvoidBottomInset: true,
      child: Column(
        children: [
          Obx(
            () => StitchTopBar(
              title: 'Journal',
              leadingIcon: Icons.arrow_back_rounded,
              onLeading: Get.back,
              trailing: IconButton(
                tooltip: 'Save',
                onPressed: controller.isLoading.value
                    ? null
                    : controller.addJournal,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(
                        Icons.save_rounded,
                        color: AppColors.primary,
                      ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                Text(_today(), style: AppTypography.caps),
                TextField(
                  controller: controller.titleC,
                  cursorColor: AppColors.primary,
                  maxLength: 100,
                  buildCounter: _hideCounter,
                  style: AppTypography.serif(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: AppColors.primary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: AppTypography.serif(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: AppColors.outlineVariant,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                TextField(
                  controller: controller.contentC,
                  cursorColor: AppColors.primary,
                  maxLength: 10000,
                  maxLines: null,
                  minLines: 12,
                  buildCounter: _hideCounter,
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.onSurface,
                    height: 1.65,
                  ),
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: AppTypography.bodyLg.copyWith(
                      color: AppColors.outlineVariant,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),
                const Divider(color: AppColors.outlineVariant),
                const SizedBox(height: AppSpacing.s10),
                Text(
                  'Mood',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                Obx(
                  () => Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14,
                    runSpacing: 12,
                    children: JournalMoods.all.map((mood) {
                      final selected =
                          controller.selectedMood.value == mood.emoji;
                      return GestureDetector(
                        onTap: () {
                          controller.selectedMood.value = mood.emoji;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : Colors.transparent,
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
                _CategoryRow(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget? _hideCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) =>
      null;

  String _today() {
    final now = DateTime.now();
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
    return 'TODAY, ${months[now.month - 1]} ${now.day}';
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.controller});

  final CreateJournalController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
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
    );
  }
}
