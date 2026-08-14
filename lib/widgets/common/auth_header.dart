import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../buttons/small_pill_button.dart';
import '../buttons/text_link_button.dart';

/// Top row shared by Login/Signup: logo badge + brand name,
/// plus a text link + pill button pair (e.g. "Sign In" / "Join Now").
class AuthHeader extends StatelessWidget {
  final String secondaryActionLabel;
  final VoidCallback onSecondaryAction;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;

  const AuthHeader({
    super.key,
    required this.secondaryActionLabel,
    required this.onSecondaryAction,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.directions_car_rounded,
            color: AppColors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        const Text('RideSharePro', style: AppTextStyles.brandTitle),
        const Spacer(),
        TextLinkButton(
          label: secondaryActionLabel,
          onPressed: onSecondaryAction,
        ),
        const SizedBox(width: 6),
        SmallPillButton(
          label: primaryActionLabel,
          onPressed: onPrimaryAction,
        ),
      ],
    );
  }
}