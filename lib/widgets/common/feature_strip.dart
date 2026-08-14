import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// White rounded strip of icon+label feature items, floating over the
/// bottom edge of [HeroBanner] via a Stack/Positioned in the screen.
/// Pass 2+ [FeatureStripItem]s; dividers are inserted automatically.
class FeatureStrip extends StatelessWidget {
  final List<FeatureStripItem> items;

  const FeatureStrip({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(_FeatureStripItemView(item: items[i]));
      if (i != items.length - 1) {
        children.add(Container(height: 24, width: 1, color: Colors.grey.shade300));
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}

class FeatureStripItem {
  final IconData icon;
  final String label;

  const FeatureStripItem({required this.icon, required this.label});
}

class _FeatureStripItemView extends StatelessWidget {
  final FeatureStripItem item;

  const _FeatureStripItemView({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryNavy.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: AppColors.primaryNavy, size: 16),
        ),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}