import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      resizeToAvoidBottomInset: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
        children: [
          const Center(
            child: StitchLottieMark(
              asset: 'assets/animations/login_animation.json',
              size: 182,
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          Text(
            'Reflection',
            textAlign: TextAlign.center,
            style: AppTypography.serif(
              fontSize: 33,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          Text(
            'Ruang tenang untuk pikiranmu.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.s40),
          StitchField(
            controller: controller.emailC,
            label: 'Alamat Email',
            hint: 'nama@email.com',
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
              onSubmitted: (_) => controller.login(),
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
              child: Text(
                'Lupa sandi?',
                style: AppTypography.caption.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Obx(
            () => StitchButton(
              label: 'Masuk',
              isLoading: controller.isLoading.value,
              onPressed: controller.login,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const _DividerLabel(label: 'ATAU'),
          const SizedBox(height: AppSpacing.s24),
          Obx(
            () => StitchGoogleButton(
              label: 'Masuk dengan Google',
              isLoading: controller.isGoogleLoading.value,
              onPressed: controller.loginWithGoogle,
            ),
          ),
          const SizedBox(height: AppSpacing.s40),
          Text(
            'Belum Punya Akun?',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm,
          ),
          TextButton(
            onPressed: () => Get.toNamed(Routes.REGISTER),
            child: Text(
              'Mulai menulis hari ini',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(label, style: AppTypography.caption),
        ),
        const Expanded(child: Divider(color: AppColors.outlineVariant)),
      ],
    );
  }
}
