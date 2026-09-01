import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class DecorativeBlobBackground extends StatelessWidget {
  const DecorativeBlobBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -60,
            child: _blob(180),
          ),
          Positioned(
            top: 260,
            right: -80,
            child: _blob(220),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: _blob(200),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: AppColors.decorativeBlob,
        shape: BoxShape.circle,
      ),
    );
  }
}