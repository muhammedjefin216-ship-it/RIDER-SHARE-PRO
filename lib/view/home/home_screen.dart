import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trips_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../../widgets/common/two_tone_title.dart';
import '../../widgets/dashboard/welcome_card.dart';
import '../../widgets/dashboard/quick_action_icon.dart';
import '../../widgets/dashboard/stat_card.dart';
import '../../widgets/dashboard/trip_list_card.dart';
import '../../widgets/dashboard/empty_trips_card.dart';
import '../../widgets/dashboard/promo_banner_card.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/trip/search_input_field.dart';
import '../../widgets/trip/dropdown_display_field.dart';
import '../../widgets/trip/category_chip_bar.dart';
import '../../widgets/trip/trip_detail_card.dart';
import '../auth/login_screen.dart';
import '../trip/find_booking_screen.dart';
import '../trip/post_trip_screen.dart';

// Flow 2nd screen (3)

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;
  int _tripsCategoryIndex = 0;
  final List<String> _tripsCategories = [
    'All Trips',
    'Hosting',
    'Travelling',
    'Past',
  ];
  static const List<int> _navPositionToTabIndex = [0, 1, -1, 2, 3, 4];
  static const List<int> _tabIndexToNavPosition = [0, 1, 3, 4, 5];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).fetchCurrentUser();
      ref.read(tripsProvider.notifier).fetchMyTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final tripsState = ref.watch(tripsProvider);
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            _buildHomeContent(authState: authState, tripsState: tripsState),
            FindRideBookingScreen(),

            _buildTripsPlaceholder(tripsState: tripsState),

            _buildPlaceholderScreen(
              icon: Icons.payments_outlined,
              title: 'Earnings',
              subtitle:
                  'Your trip earnings and payout history will appear here.',
              buttonText: 'Post a Trip',
              onPressed: _openPostTrip,
            ),

            _buildProfilePlaceholder(authState: authState),
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
        selectedIndex: _tabIndexToNavPosition[selectedIndex],
        onTap: _bottomNavTapped,
      ),
    );
  }

  void _bottomNavTapped(int navPosition) {
    if (navPosition == 2) {
      _openPostTrip();
      return;
    }
    setState(() {
      selectedIndex = _navPositionToTabIndex[navPosition];
    });
  }

  Widget _buildHomeContent({
    required dynamic authState,
    required dynamic tripsState,
  }) {
    return RefreshIndicator(
      color: AppColors.primaryNavy,
      onRefresh: () async {
        await ref.read(authProvider.notifier).fetchCurrentUser();
        await ref.read(tripsProvider.notifier).fetchMyTrips();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardTopBar(
              onNotificationTap: () {},
              hasUnreadNotification: true,
              avatarMenu: _buildAvatarMenu(),
            ),

            SizedBox(height: 8),

            WelcomeCard(
              greetingName: authState.userName ?? 'User',
              isLoadingName: authState.isLoadingUser,
              dateLabel: _getCurrentDate(),
              upcomingTripsCount: tripsState.all.length,
              onUpcomingTripsTap: () => setState(() => selectedIndex = 2),
              quickActions: [
                QuickActionIcon(
                  icon: Icons.add_circle_rounded,
                  label: 'Post Trip',
                  isHighlighted: true,
                  onTap: _openPostTrip,
                ),
                QuickActionIcon(
                  icon: Icons.search_rounded,
                  label: 'Find Ride',
                  onTap: () => setState(() => selectedIndex = 1),
                ),
                QuickActionIcon(
                  icon: Icons.alt_route_rounded,
                  label: 'My Trips',
                  onTap: () => setState(() => selectedIndex = 2),
                ),
                QuickActionIcon(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  onTap: () => setState(() => selectedIndex = 4),
                ),
              ],
            ),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.directions_car_filled_rounded,
                          label: 'HOSTED',
                          value: '${tripsState.hosted.length}',
                          subtitle: 'Total Trips',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.event_available_rounded,
                          label: 'TAKEN',
                          value: '${tripsState.guest.length}',
                          subtitle: 'Total Trips',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.credit_card_rounded,
                          label: 'CURRENCY',
                          value: '₹0',
                          subtitle: 'Total Saved',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.star_rounded,
                          label: 'RATING',
                          value: authState.userRating != null
                              ? authState.userRating!.toStringAsFixed(1)
                              : '0.0',
                          subtitle: 'User Score',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            _buildUpcomingTripsSection(tripsState: tripsState),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  PromoBannerCard(
                    title: 'Host a Ride',
                    subtitle:
                        'Earn while you commute and help others reach their destination',
                    ctaLabel: 'Get Started',
                    onCtaTap: _openPostTrip,
                  ),
                  SizedBox(height: 14),
                  PromoBannerCard(
                    title: 'Find a Ride',
                    subtitle:
                        'Affordable, safe, and social rides at your fingertips',
                    ctaLabel: 'Book Now',
                    onCtaTap: () => setState(() => selectedIndex = 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarMenu() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      offset: Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryNavy,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_outline_rounded,
          color: AppColors.white,
          size: 19,
        ),
      ),
      onSelected: (value) async {
        if (value == 'logout') {
          await _logout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 19, color: Colors.red),
              SizedBox(width: 10),
              Text('Logout', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _openPostTrip() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PostTripScreen()),
    );

    if (!mounted) return;

    await ref.read(tripsProvider.notifier).fetchMyTrips();
  }

  Widget _buildUpcomingTripsSection({required dynamic tripsState}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Upcoming Trips',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => selectedIndex = 2),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryNavy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (tripsState.isLoading)
            _buildLoadingCard()
          else if (tripsState.all.isEmpty)
            EmptyTripsCard(onFindRide: () => setState(() => selectedIndex = 1))
          else
            Column(
              children: tripsState.all
                  .take(5)
                  .map<Widget>(
                    (trip) => Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: TripListCard(
                        title: trip.route,
                        date: '${trip.date} • ${trip.time}',
                        price: trip.amount,
                        tag: trip.role == 'HOST' ? 'Hosting' : 'Booked',
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryNavy,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildTripsPlaceholder({required dynamic tripsState}) {
    return SafeArea(
      child: Column(
        children: [
          DashboardTopBar(
            onNotificationTap: () {},
            avatarMenu: _buildAvatarMenu(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TwoToneTitle(
                accentWord: 'My',
                restOfTitle: ' Trips',
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchInputField(hint: 'Search route or segment...'),
                  SizedBox(height: 12),
                  DropdownDisplayField(label: 'All Status'),
                  SizedBox(height: 16),
                  CategoryChipBar(
                    categories: _tripsCategories,
                    selectedIndex: _tripsCategoryIndex,
                    onSelected: (index) =>
                        setState(() => _tripsCategoryIndex = index),
                  ),
                  SizedBox(height: 20),
                  if (tripsState.isLoading)
                    _buildLoadingCard()
                  else if (tripsState.all.isEmpty)
                    _buildPlaceholderScreen(
                      icon: Icons.alt_route_rounded,
                      title: 'No Trips Yet',
                      subtitle:
                          'Your booked and hosted trips will appear here.',
                      buttonText: 'Post a Trip',
                      onPressed: _openPostTrip,
                    )
                  else
                    Column(
                      children: tripsState.all
                          .map<Widget>(
                            (trip) => Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: _buildTripDetailCardFromTrip(trip),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (String, String) _splitRoute(String route) {
    final parts = route.split('→').map((s) => s.trim()).toList();
    if (parts.length == 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return (parts[0], parts[1]);
    }
    return (route, '');
  }

  ({Color bg, Color text}) _statusBadgeColors(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return (bg: AppColors.hostingTagBg, text: AppColors.successGreen);
      case 'CANCELLED':
        return (bg: Color(0xffFEE2E2), text: Color(0xffDC2626));
      case 'ONGOING':
        return (bg: Color(0xffFEF3C7), text: Color(0xffB45309));
      case 'UPCOMING':
      default:
        return (bg: AppColors.lightInputBg, text: AppColors.primaryNavy);
    }
  }

  Widget _buildTripDetailCardFromTrip(dynamic trip) {
    final (from, to) = _splitRoute(trip.route as String);
    final statusColors = _statusBadgeColors(trip.status as String);

    return TripDetailCard(
      tripId: trip.tripId,
      roleBadgeLabel: trip.role,
      statusBadgeLabel: trip.status,
      statusBadgeBg: statusColors.bg,
      statusBadgeText: statusColors.text,
      price: trip.amount,
      from: from,
      to: to.isEmpty ? from : to,
      dateTimeLabel: '${trip.date}, ${trip.time}',
      availabilityLabel:
          '${trip.seats.booked}/${trip.seats.total} seats filled',
      onDetails: () {},
      onCancel: () {},
    );
  }

  Widget _buildProfilePlaceholder({required dynamic authState}) {
    return _buildPlaceholderScreen(
      icon: Icons.person_outline_rounded,
      title: authState.userName ?? 'Profile',
      subtitle: 'Manage your profile and account settings.',
      buttonText: 'Logout',
      onPressed: _logout,
    );
  }

  Widget _buildPlaceholderScreen({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightInputBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryNavy, size: 36),
            ),
            SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 22),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}
