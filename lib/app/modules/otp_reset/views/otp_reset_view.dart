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
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Verifikasi Kode',
            textAlign: TextAlign.center,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            'Kami sudah mengirim tautan reset kata sandi ke ${controller.email}.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.s40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                width: 48,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  borderRadius: AppSpacing.br8,
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Text(
                  index == 0 ? '\u2713' : '',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
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
                const Icon(Icons.mark_email_read_outlined, size: 36),
                const SizedBox(height: AppSpacing.s12),
                Text('Cek inbox Anda', style: AppTypography.titleMd),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'Buka email dari Firebase lalu ikuti tautan untuk membuat kata sandi baru.',
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
