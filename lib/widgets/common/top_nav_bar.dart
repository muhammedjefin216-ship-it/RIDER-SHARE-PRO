import 'package:flutter/material.dart';
import 'brand_logo.dart';
import '../buttons/small_pill_button.dart';

/// Header row with the brand logo on the left and a single pill
/// action button on the right (e.g. "Sign in →" on the Signup screen).
/// For screens that need two actions (text link + pill), use AuthHeader.
class TopNavBar extends StatelessWidget {
  final String actionLabel;
  final VoidCallback onActionPressed;
  final IconData? actionTrailingIcon;

  const TopNavBar({
    super.key,
    required this.actionLabel,
    required this.onActionPressed,
    this.actionTrailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BrandLogo(),
        const Spacer(),
        SmallPillButton(
          label: actionLabel,
          onPressed: onActionPressed,
          trailingIcon: actionTrailingIcon,
        ),
      ],
    );
  }
}