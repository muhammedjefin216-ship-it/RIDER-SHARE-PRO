import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class ProTipsCard extends StatelessWidget {
  final String title;
  final List<String> tips;

  const ProTipsCard({
    super.key,
    this.title = 'Pro Tips for Hosts',
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.decorativeBlob),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < tips.length; i++) ...[
            if (i != 0) const SizedBox(height: 6),
            _TipRow(text: tips[i]),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String text;

  const _TipRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.check_circle, size: 13, color: AppColors.primaryNavy),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: AppColors.primaryNavy, height: 1.3),
          ),
        ),
      ],
    );
  }
}