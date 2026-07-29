import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/trips_provider.dart';
import 'login_screen.dart';
import 'post_trip_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  final Color primaryGreen = const Color(0xff16C763);
  final Color darkGreen = const Color(0xff006B35);
  final Color backgroundColor = const Color(0xffF7F8FC);

  @override
  void initState() {
    super.initState();
    // Deferred to after the first frame — calling this directly
    // in initState would try to modify the authProvider while
    // the widget tree is still building, which Riverpod blocks.
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
      backgroundColor: backgroundColor,

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: darkGreen,
        elevation: 4,
        child: const Icon(Icons.add_reaction_outlined, color: Colors.white),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomNavItem(
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                index: 0,
              ),
              _bottomNavItem(
                icon: Icons.directions_car_outlined,
                label: 'Host',
                index: 1,
              ),
              _bottomNavItem(
                icon: Icons.business_center_outlined,
                label: 'Trips',
                index: 2,
              ),
              _bottomNavItem(icon: Icons.search, label: 'Search', index: 3),
              _bottomNavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Earnings',
                index: 4,
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco_outlined, color: darkGreen, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          'RideSharePro',
                          style: TextStyle(
                            color: darkGreen,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat_bubble,
                        size: 20,
                        color: Color(0xff1F2937),
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 22,
                        color: Color(0xff374151),
                      ),
                    ),

                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        size: 22,
                        color: Color(0xff374151),
                      ),
                      onSelected: (value) async {
                        if (value == 'logout') {
                          await ref.read(authProvider.notifier).logout();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // GREETING — shows the real logged-in user's name
              // once fetchCurrentUser() completes.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: authState.isLoadingUser
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        authState.userName != null
                            ? 'Hi, ${authState.userName}'
                            : '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff172033),
                        ),
                      ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xff00843D),
                        size: 20,
                      ),
                      hintText: 'Where to?',
                      hintStyle: TextStyle(
                        color: Color(0xff9CA3AF),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _actionCard(
                        title: 'Book a Ride',
                        subtitle: 'Sustainable travel',
                        icon: Icons.directions_car_outlined,
                        backgroundColor: primaryGreen,
                        textColor: darkGreen,
                        iconColor: darkGreen,
                        onTap: () {},
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _actionCard(
                        title: 'Host a Trip',
                        subtitle: 'Earn rewards',
                        icon: Icons.person_add_alt_1_outlined,
                        backgroundColor: Colors.white,
                        textColor: darkGreen,
                        iconColor: darkGreen,
                        borderColor: const Color(0xffC9D9CC),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PostTripScreen(),
                            ),
                          ).then((_) {
                            // Refresh trips list in case a new one was posted.
                            ref.read(tripsProvider.notifier).fetchMyTrips();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        label: 'TRIPS HOSTED',
                        value: '${tripsState.hosted.length}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        label: 'TRIPS TAKEN',
                        value: '${tripsState.guest.length}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        label: 'YOUR RATING',
                        value: authState.userRating != null
                            ? authState.userRating!.toStringAsFixed(1)
                            : '0.0',
                        showStar: true,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Text(
                      'Recent Trips',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff172033),
                      ),
                    ),

                    const Spacer(),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (tripsState.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (tripsState.all.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    tripsState.errorMessage ?? 'No trips yet',
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 12,
                    ),
                  ),
                )
              else
                ...tripsState.all.take(5).map(
                  (trip) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _tripCard(
                        image: 'assets/images/car.jpg',
                        title: trip.route,
                        date: '${trip.date} • ${trip.time}',
                        price: trip.amount,
                        tag: trip.role == 'HOST' ? 'Hosting' : 'Booked',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    bool showStar = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xff9CA3AF),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff172033),
                ),
              ),
              if (showStar) ...[
                const SizedBox(width: 3),
                const Icon(Icons.star, size: 15, color: Color(0xffF5B301)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(9),
          border: borderColor != null ? Border.all(color: borderColor) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 23),

            const SizedBox(height: 7),

            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripCard({
    required String image,
    required String title,
    required String date,
    required String price,
    required String tag,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              image,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 45,
                  height: 45,
                  color: const Color(0xffE5E7EB),
                  child: const Icon(Icons.directions_car, color: Colors.grey),
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172033),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  date,
                  style: const TextStyle(fontSize: 9, color: Color(0xff6B7280)),
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xffDDF8E5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: darkGreen, fontSize: 7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? darkGreen : const Color(0xff374151),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isSelected ? darkGreen : const Color(0xff374151),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}