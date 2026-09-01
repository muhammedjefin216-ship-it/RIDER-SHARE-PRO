import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../buttons/small_pill_button.dart';
import '../buttons/text_link_button.dart';


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
          child:  Icon(
            Icons.directions_car_rounded,
            color: AppColors.white,
            size: 22,
          ),
        ),
         SizedBox(width: 10),
         Text('RideSharePro', style: AppTextStyles.brandTitle),
         Spacer(),
        TextLinkButton(
          label: secondaryActionLabel,
          onPressed: onSecondaryAction,
        ),
         SizedBox(width: 6),
        SmallPillButton(
          label: primaryActionLabel,
          onPressed: onPrimaryAction,
        ),
      ],
    );
  }
}