import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      currentTab: StitchTab.journal,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.CREATE_JOURNAL),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded),
      ),
      child: StreamBuilder<List<JournalEntry>>(
        stream: controller.watchEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <JournalEntry>[];
          return Obx(() {
            final visible = controller.visibleEntries(entries);
            return ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
              children: [
                StitchTopBar(
                  title: 'Journal',
                  leading: GestureDetector(
                    onTap: controller.openProfile,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.surfaceHigh,
                      backgroundImage: controller.photoUrl == null
                          ? null
                          : NetworkImage(controller.photoUrl!),
                      child: controller.photoUrl == null
                          ? Text(
                              controller.userName.characters.isNotEmpty
                                  ? controller.userName.characters.first.toUpperCase()
                                  : 'U',
                              style: AppTypography.bodySm.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Obx(
                    () => Text(
                      controller.dailyQuote.value,
                      style: AppTypography.titleMd.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                _SearchField(controller: controller),
                const SizedBox(height: AppSpacing.s16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: HomeController.filters
                        .map(
                          (filter) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: StitchPill(
                              label: filter,
                              selected:
                                  controller.selectedFilter.value == filter,
                              onTap: () =>
                                  controller.selectedFilter.value = filter,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (snapshot.hasError)
                  _MessageState(
                    icon: Icons.error_outline,
                    title: 'Jurnal belum bisa dimuat',
                    message: snapshot.error.toString(),
                  )
                else if (visible.isEmpty)
                  const _MessageState(
                    icon: Icons.edit_note_rounded,
                    title: 'Belum ada catatan',
                    message: 'Mulai dengan menulis satu momen kecil hari ini.',
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visible.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      final entry = visible[index];
                      return StitchJournalCard(
                        entry: entry,
                        onTap: () => Get.toNamed(
                          Routes.DETAIL_JOURNAL,
                          arguments: {'docId': entry.id},
                        ),
                        onFavorite: () => controller.toggleFavorite(entry),
                      );
                    },
                  ),
              ],
            );
          });
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchC,
      onChanged: (value) => controller.searchQuery.value = value,
      cursorColor: AppColors.primary,
      style: AppTypography.bodyMd,
      decoration: InputDecoration(
        hintText: 'Cari jurnal...',
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        filled: true,
        fillColor: AppColors.surfaceLow,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.br8,
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.br8,
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.br8,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: AppColors.muted),
            const SizedBox(height: AppSpacing.s16),
            Text(title, style: AppTypography.titleMd),
            const SizedBox(height: AppSpacing.s8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodySm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
