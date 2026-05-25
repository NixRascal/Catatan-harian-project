import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
        children: [
          const Center(
            child: StitchLottieMark(
              asset: 'assets/animations/register_animation.json',
              size: 160,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Reflection',
            textAlign: TextAlign.center,
            style: AppTypography.serif(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Mulai perjalanan refleksi Anda.',
            textAlign: TextAlign.center,
            style: AppTypography.serif(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          StitchField(
            controller: controller.nameC,
            label: 'Nama Lengkap',
            hint: 'Jane Doe',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.s12),
          StitchField(
            controller: controller.emailC,
            label: 'Alamat Email',
            hint: 'jane@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.s12),
          Obx(
            () => StitchField(
              controller: controller.passwordC,
              label: 'Kata Sandi',
              hint: 'Minimal 6 karakter',
              obscureText: controller.obscurePassword.value,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.register(),
              suffix: IconButton(
                icon: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s28),
          Obx(
            () => StitchButton(
              label: 'Daftar',
              isLoading: controller.isLoading.value,
              onPressed: controller.register,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            children: [
              const Expanded(child: Divider(height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'ATAU',
                  style: AppTypography.caption,
                ),
              ),
              const Expanded(child: Divider(height: 1)),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Obx(
            () => StitchGoogleButton(
              label: 'Daftar dengan Google',
              isLoading: controller.isGoogleLoading.value,
              onPressed: controller.registerWithGoogle,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sudah punya akun?', style: AppTypography.bodySm),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  'Masuk ke akunmu',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
