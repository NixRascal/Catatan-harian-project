import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/otp_reset_controller.dart';

class OtpResetView extends GetView<OtpResetController> {
  const OtpResetView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          const SizedBox(height: AppSpacing.s40),
          const Icon(
            Icons.mark_email_read_outlined,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Email Terkirim',
            textAlign: TextAlign.center,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            'Kami sudah mengirim tautan reset kata sandi ke:',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            controller.email,
            textAlign: TextAlign.center,
            style: AppTypography.titleMd.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.s40),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: AppSpacing.br12,
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              children: [
                const Icon(Icons.info_outline_rounded, size: 28),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  'Buka email Anda lalu klik tautan untuk membuat kata sandi baru. Cek juga folder spam jika tidak ditemukan.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          StitchButton(
            label: 'Kembali ke Login',
            icon: Icons.login_rounded,
            onPressed: () => Get.offAllNamed(Routes.LOGIN),
          ),
        ],
      ),
    );
  }
}
