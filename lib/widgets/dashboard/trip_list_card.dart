import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class TripListCard extends StatelessWidget {
  final String title;
  final String date;
  final String price;
  final String tag;
  final VoidCallback? onTap;

  const TripListCard({
    super.key,
    required this.title,
    required this.date,
    required this.price,
    required this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHosting = tag == 'Hosting';

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding:  EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.lightInputBg,
                  borderRadius: BorderRadius.circular(13),
                ),
                child:  Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.primaryNavy,
                  size: 24,
                ),
              ),
               SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                     SizedBox(height: 6),
                    Row(
                      children: [
                         Icon(Icons.schedule_rounded,
                            size: 12, color: AppColors.textSecondary),
                         SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
               SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style:  TextStyle(
                      color: AppColors.primaryNavy,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                   SizedBox(height: 6),
                  Container(
                    padding:
                         EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isHosting
                          ? AppColors.hostingTagBg
                          : AppColors.lightInputBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isHosting
                            ? AppColors.successGreen
                            : AppColors.primaryNavy,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}