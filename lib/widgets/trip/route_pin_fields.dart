import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'plain_text_field.dart';

/// "Leaving from..." / "Going to..." route fields with a green and
/// red pin, connected by a dotted vertical line — matches the Figma
/// route-details layout. [middleContent] slots in the "Add
/// intermediate stop" button between the two fields.
class RoutePinFields extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final Widget? middleContent;

  const RoutePinFields({
    super.key,
    required this.fromController,
    required this.toController,
    this.middleContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pin + dotted connector column
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Icon(Icons.circle, size: 10, color: AppColors.successGreen),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 1,
                          child: CustomPaint(painter: _DottedLinePainter()),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Icon(Icons.circle, size: 10, color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    PlainTextField(controller: fromController, hint: 'Leaving from...'),
                    if (middleContent != null) ...[
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerLeft, child: middleContent),
                    ],
                    const SizedBox(height: 10),
                    PlainTextField(controller: toController, hint: 'Going to...'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashHeight), paint);
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}