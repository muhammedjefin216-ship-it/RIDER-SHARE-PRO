import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';


class TextLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const TextLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: AppTextStyles.linkSmall),
    );
  }
}