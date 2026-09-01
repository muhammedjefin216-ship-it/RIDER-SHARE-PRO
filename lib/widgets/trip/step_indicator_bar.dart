import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StepItem {
  final String label;
  const StepItem(this.label);
}

enum _StepState { completed, active, upcoming }


class StepIndicatorBar extends StatelessWidget {
  final List<StepItem> steps;
  final int currentIndex;

  const StepIndicatorBar({super.key, required this.steps, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < steps.length; i++) {
      final state = i < currentIndex
          ? _StepState.completed
          : i == currentIndex
              ? _StepState.active
              : _StepState.upcoming;
      children.add(_StepPill(number: i + 1, label: steps[i].label, state: state));
      if (i != steps.length - 1) {
        children.add(Container(
          width: 32,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: AppColors.border,
        ));
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }
}

class _StepPill extends StatelessWidget {
  final int number;
  final String label;
  final _StepState state;

  const _StepPill({required this.number, required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    final isActive = state == _StepState.active;
    final isCompleted = state == _StepState.completed;

    final pillBg = isActive
        ? AppColors.primaryNavy
        : isCompleted
            ? AppColors.lightInputBg
            : const Color(0xffEDEFF3);
    final textColor = isActive
        ? AppColors.white
        : isCompleted
            ? AppColors.textPrimary
            : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: pillBg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: isCompleted
                ? AppColors.primaryNavy
                : (isActive ? AppColors.white : const Color(0xffD0D5DD)),
            child: isCompleted
                ? const Icon(Icons.check, color: AppColors.white, size: 12)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? AppColors.primaryNavy : AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}