import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../data/journal_entry.dart';
import '../data/journal_mood.dart';
import '../routes/app_pages.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum StitchTab { mood, journal, calendar }

class StitchScaffold extends StatelessWidget {
  const StitchScaffold({
    super.key,
    required this.child,
    this.currentTab,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
  });

  final Widget child;
  final StitchTab? currentTab;
  final Widget? floatingActionButton;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar:
          currentTab == null ? null : StitchBottomNav(currentTab: currentTab!),
    );
  }
}

class StitchTopBar extends StatelessWidget {
  const StitchTopBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.onLeading,
    this.trailingIcon,
    this.onTrailing,
    this.leading,
    this.trailing,
  });

  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onLeading;
  final IconData? trailingIcon;
  final VoidCallback? onTrailing;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: leading ??
                  (leadingIcon == null
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: Icon(leadingIcon, size: 20),
                          color: AppColors.primary,
                          onPressed: onLeading,
                        )),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.serif(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: trailing ??
                  (trailingIcon == null
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: Icon(trailingIcon, size: 20),
                          color: AppColors.primary,
                          onPressed: onTrailing,
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

class StitchBottomNav extends StatelessWidget {
  const StitchBottomNav({super.key, required this.currentTab});

  final StitchTab currentTab;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Container(
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.outlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  label: 'Mood',
                  selected: currentTab == StitchTab.mood,
                  onTap: () => Get.offNamed(Routes.MOOD),
                ),
                _NavItem(
                  icon: Icons.edit_note_rounded,
                  label: 'Journal',
                  selected: currentTab == StitchTab.journal,
                  onTap: () => Get.offNamed(Routes.HOME),
                ),
                _NavItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Calendar',
                  selected: currentTab == StitchTab.calendar,
                  onTap: () => Get.offNamed(Routes.CALENDAR),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: selected ? AppColors.primaryOn : AppColors.onSurfaceVariant,
            size: selected ? 22 : 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );

    return InkWell(
      onTap: selected ? null : onTap,
      borderRadius: AppSpacing.br16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: content,
      ),
    );
  }
}

class StitchButton extends StatelessWidget {
  const StitchButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon = Icons.arrow_forward_rounded,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryOn,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.br8),
          textStyle: AppTypography.button.copyWith(fontSize: 13),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label),
                  if (icon != null) ...[
                    const SizedBox(width: 10),
                    Icon(icon, size: 16),
                  ],
                ],
              ),
      ),
    );
  }
}

class StitchGoogleButton extends StatelessWidget {
  const StitchGoogleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.br8),
          textStyle: AppTypography.button.copyWith(fontSize: 13),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppSpacing.br6,
                    ),
                    child: const Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(label),
                ],
              ),
      ),
    );
  }
}

class StitchField extends StatelessWidget {
  const StitchField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      cursorColor: AppColors.primary,
      style: AppTypography.bodyMd,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffix,
        labelStyle: AppTypography.caption.copyWith(color: AppColors.muted),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.2),
        ),
        contentPadding: const EdgeInsets.only(top: 8, bottom: 12),
      ),
    );
  }
}

class StitchPill extends StatelessWidget {
  const StitchPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceLowest,
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.outlineVariant,
      ),
      labelStyle: AppTypography.caption.copyWith(
        color: selected ? AppColors.primaryOn : AppColors.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.br16),
    );
  }
}

class StitchLottieMark extends StatelessWidget {
  const StitchLottieMark({
    super.key,
    required this.asset,
    this.icon,
    this.size = 116,
    this.borderRadius = 999,
    this.iconColor = AppColors.primary,
  });

  final String asset;
  final IconData? icon;
  final double size;
  final double borderRadius;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Lottie.asset(asset, fit: BoxFit.cover),
          ),
          if (icon != null)
            Icon(icon!, size: size * 0.28, color: iconColor),
        ],
      ),
    );
  }
}

class StitchJournalCard extends StatelessWidget {
  const StitchJournalCard({
    super.key,
    required this.entry,
    required this.onTap,
    this.onFavorite,
  });

  final JournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final moodColor = JournalMoods.byEmoji(entry.mood).color;
    return Material(
      color: moodColor,
      borderRadius: AppSpacing.br8,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.br8,
        child: Ink(
          decoration: BoxDecoration(
            color: moodColor,
            borderRadius: AppSpacing.br8,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_dateLabel(entry.createdAt), style: AppTypography.caps),
                    const Spacer(),
                    GestureDetector(
                      onTap: onFavorite,
                      child: Text(
                        entry.isFavorite ? '\u2605' : entry.mood,
                        style: TextStyle(
                          fontSize: entry.isFavorite ? 22 : 28,
                          color: entry.isFavorite
                              ? const Color(0xFFE3A600)
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  entry.displayTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.preview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _SmallTag(entry.category),
                    _SmallTag(entry.moodLabel),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(date.year, date.month, date.day);
    if (entryDay == today) return 'HARI INI';
    if (entryDay == today.subtract(const Duration(days: 1))) return 'KEMARIN';
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
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _SmallTag extends StatelessWidget {
  const _SmallTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: AppSpacing.br6,
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.onSurfaceVariant,
          fontSize: 10,
        ),
      ),
    );
  }
}
