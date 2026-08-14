import 'package:flutter/material.dart';

/// Small colored notice strip — icon + message. Used for the amber
/// "select from suggestions" warning, and reusable for similar
/// warning/info/success banners elsewhere. Pass [title] for a bold
/// heading above the message (e.g. "Cancellation Policy").
class InlineNotice extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  const InlineNotice({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.info_outline,
    this.backgroundColor = const Color(0xffFFF7ED),
    this.borderColor = const Color(0xffFDE9CE),
    this.iconColor = const Color(0xffD97706),
    this.textColor = const Color(0xff92400E),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(title!,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 2),
                ],
                Text(message, style: TextStyle(fontSize: 11, color: textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}