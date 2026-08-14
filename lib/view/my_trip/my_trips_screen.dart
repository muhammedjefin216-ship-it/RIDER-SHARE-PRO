import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/two_tone_title.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/trip/search_input_field.dart';
import '../../widgets/trip/dropdown_display_field.dart';
import '../../widgets/trip/category_chip_bar.dart';
import '../../widgets/trip/trip_detail_card.dart';
import '../../widgets/trip/explore_more_card.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedCategoryIndex = 0;
  int _currentBottomNavIndex = 3;

  final List<String> _categories = [
    'All Trips',
    'Hosting',
    'Travelling',
    'Past',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            DashboardTopBar(
              onNotificationTap: () {},
              avatarMenu: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: AppColors.white, size: 20),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TwoToneTitle(
                      accentWord: 'My',
                      restOfTitle: ' Trips',
                      fontSize: 24,
                    ),
                    SizedBox(height: 16),

                    SearchInputField(hint: 'Search route or segment...'),
                    SizedBox(height: 12),

                    DropdownDisplayField(label: 'All Status'),
                    SizedBox(height: 16),

                    CategoryChipBar(
                      categories: _categories,
                      selectedIndex: _selectedCategoryIndex,
                      onSelected: (index) {
                        setState(() => _selectedCategoryIndex = index);
                      },
                    ),
                    SizedBox(height: 20),
                    TripDetailCard(
                      tripId: '06DF15FA',
                      roleBadgeLabel: 'HOST',
                      statusBadgeLabel: 'UPCOMING',
                      price: '₹0',
                      from: 'Malappuram',
                      to: 'Kozhikode',
                      dateTimeLabel: '29 Jul 2026, 09:30',
                      availabilityLabel: '0/3 seats filled',
                      onDetails: () {},
                      onCancel: () {},
                    ),

                    SizedBox(height: 20),

                    ExploreMoreCard(
                      subtitle:
                          'Plan your next journey or host a ride to fill this space with adventures.',
                      onCtaTap: () {},
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        items: [
          BottomNavItemData(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Home',
          ),
          BottomNavItemData(
            icon: Icons.search_outlined,
            selectedIcon: Icons.search_rounded,
            label: 'Find a Ride',
          ),
          BottomNavItemData(
            icon: Icons.add_circle_outline_rounded,
            selectedIcon: Icons.add_circle_rounded,
            label: 'Post a Trip',
          ),
          BottomNavItemData(
            icon: Icons.alt_route_outlined,
            selectedIcon: Icons.alt_route_rounded,
            label: 'Trips',
          ),
          BottomNavItemData(
            icon: Icons.payments_outlined,
            selectedIcon: Icons.payments_rounded,
            label: 'Earnings',
          ),
          BottomNavItemData(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
        selectedIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }
}
