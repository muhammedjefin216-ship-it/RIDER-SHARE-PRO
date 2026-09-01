import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class SearchInputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchInputField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.hintText, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.hintText),
        filled: true,
        fillColor: AppColors.lightInputBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}