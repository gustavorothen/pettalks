import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool filled;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.filled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: filled ? AppColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: filled ? null : Border.all(color: AppColors.dark, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  icon,
                  color: filled ? Colors.white : AppColors.dark,
                ),
              ),
            Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: filled ? Colors.white : AppColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
