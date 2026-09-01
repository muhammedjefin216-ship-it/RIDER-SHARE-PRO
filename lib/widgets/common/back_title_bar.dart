import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'two_tone_title.dart';


class BackTitleBar extends StatelessWidget {
  final String accentWord;
  final String restOfTitle;
  final VoidCallback? onBack;

  const BackTitleBar({
    super.key,
    required this.accentWord,
    required this.restOfTitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(12, 12, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            icon:  Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
           SizedBox(width: 4),
          TwoToneTitle(
            accentWord: accentWord,
            restOfTitle: restOfTitle,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}