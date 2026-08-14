import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'two_tone_title.dart';

/// White top bar with a back arrow and a two-tone title
/// (e.g. "Find" gold + " your Trip" navy). Reusable on any screen
/// that needs this simple back+title header instead of the full
/// [TopNavBar] used on Signup.
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
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 4),
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