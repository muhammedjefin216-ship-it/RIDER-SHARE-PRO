import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharepro/providers/notification_provider.dart';
import 'package:ridesharepro/view/earnings/earning_screen.dart';
import 'package:ridesharepro/view/my_trip/my_trips_screen.dart';
import 'package:ridesharepro/view/notification/notification_screen.dart';
import 'package:ridesharepro/view/profile/profile_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trips_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../../widgets/dashboard/welcome_card.dart';
import '../../widgets/dashboard/quick_action_icon.dart';
import '../../widgets/dashboard/stat_card.dart';
import '../../widgets/dashboard/trip_list_card.dart';
import '../../widgets/dashboard/empty_trips_card.dart';
import '../../widgets/dashboard/promo_banner_card.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../auth/login_screen.dart';
import '../trip/find_booking_screen.dart';
import '../trip/post_trip_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // IndexedStack tab index: 0 Home, 1 Find Ride, 2 Trips, 3 Earnings, 4 Profile.
  // "Post a Trip" in the bottom nav is a push action, not a tab — see
  // _bottomNavTapped() below for the nav-position -> tab-index mapping.
  int selectedIndex = 0;

  // Bottom nav has 6 visual positions; position 2 ("Post a Trip") doesn't
  // map to a tab. These arrays convert between nav position and tab index.
  static const List<int> _navPositionToTabIndex = [0, 1, -1, 2, 3, 4];
  static const List<int> _tabIndexToNavPosition = [0, 1, 3, 4, 5];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).fetchCurrentUser();
      ref.read(tripsProvider.notifier).fetchMyTrips();
      ref.read(notificationsProvider.notifier).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final tripsState = ref.watch(tripsProvider);
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            // HOME
            _buildHomeContent(
              authState: authState,
              tripsState: tripsState,
              notificationsState: notificationsState,
            ),

            // FIND RIDE
            const FindRideBookingScreen(),

            // MY TRIPS — now its own screen, reads tripsProvider directly
            const MyTripScreen(),

            // EARNINGS
            const EarningScreen(),

            // PROFILE
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        items: const [
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
            label: 'My Trips',
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
      // "Post a Trip" — push action, doesn't change the active tab.
      _openPostTrip();
      return;
    }
    setState(() {
      selectedIndex = _navPositionToTabIndex[navPosition];
    });
  }

  // ============================================================
  // HOME CONTENT
  // ============================================================

  Widget _buildHomeContent({
    required dynamic authState,
    required dynamic tripsState,
    required dynamic notificationsState,
  }) {
    return RefreshIndicator(
      color: AppColors.primaryNavy,
      onRefresh: () async {
        await ref.read(authProvider.notifier).fetchCurrentUser();
        await ref.read(tripsProvider.notifier).fetchMyTrips();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardTopBar(
              onNotificationTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              hasUnreadNotification: notificationsState.unreadCount > 0,
              avatarMenu: _buildAvatarMenu(),
            ),

            const SizedBox(height: 8),

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

            const SizedBox(height: 20),

            // 2x2 stats grid: Hosted / Taken / Total Saved / Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      const SizedBox(width: 10),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.credit_card_rounded,
                          label: 'CURRENCY',
                          // TODO: wire to real "total saved" field once
                          // that value exists on authState/tripsState.
                          value: '₹0',
                          subtitle: 'Total Saved',
                        ),
                      ),
                      const SizedBox(width: 10),
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

            const SizedBox(height: 24),

            _buildUpcomingTripsSection(tripsState: tripsState),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  PromoBannerCard(
                    title: 'Host a Ride',
                    subtitle:
                        'Earn while you commute and help others reach their destination',
                    ctaLabel: 'Get Started',
                    onCtaTap: _openPostTrip,
                  ),
                  const SizedBox(height: 14),
                  PromoBannerCard(
                    title: 'Find a Ride',
                    subtitle: 'Affordable, safe, and social rides at your fingertips',
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

  // ============================================================
  // AVATAR MENU (logout)
  // ============================================================

  Widget _buildAvatarMenu() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.primaryNavy,
          shape: BoxShape.circle,
        ),
        child: const Icon(
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
        const PopupMenuItem(
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

  // ============================================================
  // LOGOUT (LOGIC UNTOUCHED)
  // ============================================================

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ============================================================
  // OPEN POST TRIP (LOGIC UNTOUCHED)
  // ============================================================

  Future<void> _openPostTrip() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostTripScreen()),
    );

    if (!mounted) return;

    await ref.read(tripsProvider.notifier).fetchMyTrips();
  }

  // ============================================================
  // UPCOMING TRIPS (still shown on the Home dashboard)
  // ============================================================

  Widget _buildUpcomingTripsSection({required dynamic tripsState}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
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
                child: const Text(
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
          const SizedBox(height: 12),
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
                      padding: const EdgeInsets.only(bottom: 10),
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
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryNavy,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  // ============================================================
  // CURRENT DATE (LOGIC UNTOUCHED)
  // ============================================================

  String _getCurrentDate() {
    final now = DateTime.now();

    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];

    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}