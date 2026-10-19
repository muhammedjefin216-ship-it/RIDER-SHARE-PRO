import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Functional status filter dropdown — same light-pill visual style
/// as the old decorative DropdownDisplayField, but actually opens a
/// menu and reports the selected value back via [onChanged].
class StatusFilterDropdown extends StatelessWidget {
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const StatusFilterDropdown({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: selectedValue,
      onSelected: onChanged,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => options
          .map(
            (option) => PopupMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  color: option == selectedValue ? AppColors.primaryNavy : AppColors.textPrimary,
                  fontWeight: option == selectedValue ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightInputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedValue, style: const TextStyle(color: AppColors.textLabel, fontSize: 14)),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textLabel),
          ],
        ),
      ),
    );
  }
}