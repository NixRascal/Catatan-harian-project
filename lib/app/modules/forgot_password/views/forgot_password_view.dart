import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/stitch_widgets.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          StitchTopBar(
            title: '',
            leadingIcon: Icons.arrow_back_rounded,
            onLeading: Get.back,
          ),
          const SizedBox(height: AppSpacing.s12),
          const Center(
            child: StitchLottieMark(
              asset: 'assets/animations/forgot_reflection.json',
              icon: Icons.cloud_outlined,
              size: 132,
              iconColor: Colors.white70,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Reflection',
            textAlign: TextAlign.center,
            style: AppTypography.serif(
              fontSize: 27,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          Text(
            'Lupa Kata Sandi?',
            textAlign: TextAlign.center,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.s10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'Masukkan alamat email Anda untuk menerima kode pemulihan kata sandi.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: StitchField(
              controller: controller.emailC,
              label: 'Alamat Email',
              hint: 'nama@email.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendPasswordReset(),
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Obx(
              () => StitchButton(
                label: 'Kirim Kode',
                isLoading: controller.isLoading.value,
                onPressed: controller.sendPasswordReset,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          TextButton(
            onPressed: () => Get.offNamed(Routes.LOGIN),
            child: Text(
              'Kembali ke Login',
              style: AppTypography.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
