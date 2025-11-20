import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.dark,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.grey,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const feedUserName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const feedPetName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const feedText = TextStyle(
    fontSize: 14,
    color: AppColors.dark,
  );
}
