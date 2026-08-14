import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// -/value/+ stepper row used for seat count (and reusable anywhere
/// else a bounded integer stepper is needed).
class StepperCounter extends StatelessWidget {
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const StepperCounter({
    super.key,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperButton(icon: Icons.remove, onTap: onDecrement),
        Expanded(
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNavy,
              ),
            ),
          ),
        ),
        _StepperButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xffF3F4F6) : AppColors.lightInputBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled ? const Color(0xffD1D5DB) : AppColors.primaryNavy,
        ),
      ),
    );
  }
}