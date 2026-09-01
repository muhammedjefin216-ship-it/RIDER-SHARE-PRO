import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class PlainTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? prefixIcon;
  final TextInputType keyboardType;

  const PlainTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.hintText, fontSize: 13),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: const Color(0xffF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryNavy, width: 1.4),
        ),
      ),
    );
  }
}