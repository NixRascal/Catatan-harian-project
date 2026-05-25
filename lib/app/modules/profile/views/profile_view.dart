import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/journal_entry.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      child: StreamBuilder<List<JournalEntry>>(
        stream: controller.watchEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <JournalEntry>[];
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
            children: [
              StitchTopBar(
                title: 'Profil',
                leadingIcon: Icons.arrow_back_rounded,
                onLeading: Get.back,
              ),
              const SizedBox(height: AppSpacing.s12),
              GetBuilder<ProfileController>(
                builder: (_) => _ProfileCard(controller: controller),
              ),
              const SizedBox(height: AppSpacing.s24),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.note_alt_outlined,
                      label: 'TOTAL NOTES',
                      value: '${entries.length}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.local_fire_department_outlined,
                      label: 'STREAK',
                      value: '${controller.streak(entries)} Days',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              _WideStatCard(
                icon: Icons.sentiment_satisfied_alt_rounded,
                label: 'FAV MOOD',
                value:
                    '${controller.favoriteMood(entries).label} ${controller.favoriteMood(entries).emoji}',
              ),
              const SizedBox(height: AppSpacing.s32),
              Text('AKUN', style: AppTypography.caps),
              const SizedBox(height: AppSpacing.s12),
              _AccountPanel(controller: controller),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.br8,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.surfaceHigh,
            backgroundImage: controller.photoUrl == null
                ? null
                : NetworkImage(controller.photoUrl!),
            child: controller.photoUrl == null
                ? Text(
                    controller.displayName.characters.first.toUpperCase(),
                    style: AppTypography.headlineMd,
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(controller.displayName, style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.s4),
          Text(controller.email, style: AppTypography.bodySm),
          const SizedBox(height: AppSpacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12),
              const SizedBox(width: AppSpacing.s6),
              Text(controller.memberSince(), style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.s20),
          OutlinedButton(
            onPressed: () => _showEditDialog(context, controller),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ProfileController controller) {
    controller.nameC.text = controller.displayName;
    Get.defaultDialog(
      title: 'Edit Profile',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller.nameC,
          decoration: const InputDecoration(labelText: 'Nama'),
        ),
      ),
      textCancel: 'Batal',
      textConfirm: 'Simpan',
      confirmTextColor: Colors.white,
      onConfirm: controller.updateName,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.br8,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.muted),
              const SizedBox(width: AppSpacing.s6),
              Text(label, style: AppTypography.caps.copyWith(fontSize: 10)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.serif(
              fontSize: 27,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WideStatCard extends StatelessWidget {
  const _WideStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.muted),
              const SizedBox(width: AppSpacing.s6),
              Text(label, style: AppTypography.caps.copyWith(fontSize: 10)),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          Text(
            value,
            style: AppTypography.serif(
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountPanel extends StatelessWidget {
  const _AccountPanel({required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLowest,
      borderRadius: AppSpacing.br8,
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppSpacing.br8,
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          children: [
            Obx(
              () => _AccountRow(
                icon: Icons.delete_outline_rounded,
                label: controller.isDeletingAccount.value
                    ? 'Menghapus akun...'
                    : 'Hapus Akun',
                color: AppColors.error,
                onTap: controller.isDeletingAccount.value
                    ? null
                    : controller.confirmDeleteAccount,
              ),
            ),
            const Divider(height: 1, color: AppColors.outlineVariant),
            _AccountRow(
              icon: Icons.logout_rounded,
              label: 'Keluar Akun',
              color: AppColors.onSurface,
              onTap: controller.logout,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 19),
      title: Text(
        label,
        style: AppTypography.bodySm.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      dense: true,
    );
  }
}
