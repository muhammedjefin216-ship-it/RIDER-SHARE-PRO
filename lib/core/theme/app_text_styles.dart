import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTextStyles {
  AppTextStyles._();

  static const TextStyle brandTitle = TextStyle(
    color: AppColors.primaryBlue,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle pageTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle subtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    height: 1.3,
  );

  static const TextStyle fieldLabel = TextStyle(
    color: AppColors.textLabel,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle hint = TextStyle(
    color: AppColors.hintText,
    fontSize: 14,
  );

  static const TextStyle linkSmall = TextStyle(
    color: AppColors.primaryBlue,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textMuted,
    fontSize: 13,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}