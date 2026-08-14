import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Navy rounded-bottom card summarizing the active search — "SEARCHING
/// FOR" label, route line, an edit (pencil) button, and a row of pill
/// chips underneath (date, passenger count, etc. — pass any via [pills]).
class SearchSummaryBanner extends StatelessWidget {
  final String from;
  final String to;
  final VoidCallback onEdit;
  final List<Widget> pills;

  const SearchSummaryBanner({
    super.key,
    required this.from,
    required this.to,
    required this.onEdit,
    this.pills = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SEARCHING FOR',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            from,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.arrow_forward,
                              color: AppColors.white, size: 15),
                        ),
                        Flexible(
                          child: Text(
                            to,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_outlined,
                      color: AppColors.white, size: 17),
                ),
              ),
            ],
          ),
          if (pills.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(children: pills),
          ],
        ],
      ),
    );
  }
}