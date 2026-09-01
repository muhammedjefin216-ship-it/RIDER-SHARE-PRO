import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class GenderSelector extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    this.options = const ['Male', 'Female', 'Other'],
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryNavy.withOpacity(0.12)
                    : AppColors.lightInputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryNavy : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}