import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../../widgets/common/two_tone_title.dart';
import '../../widgets/trip/search_input_field.dart';
import '../../widgets/trip/status_filter_dropdown.dart';
import '../../widgets/trip/category_chip_bar.dart';
import '../../widgets/trip/trip_detail_card.dart';
import '../notification/notification_screen.dart';
import '../trip/post_trip_screen.dart';
import '../trip/trip_details_screen.dart';

/// My Trips tab, extracted out of home_screen.dart into its own screen.
/// Reads tripsProvider directly (same pattern ProfileScreen/EarningScreen
/// use for authProvider/tripsProvider) — HomeScreen already calls
/// fetchMyTrips() on app start, so this screen doesn't need to fetch
/// again on its own init; pull-to-refresh below covers manual refresh.
class MyTripScreen extends ConsumerStatefulWidget {
  const MyTripScreen({super.key});

  @override
  ConsumerState<MyTripScreen> createState() => _MyTripScreenState();
}

class _MyTripScreenState extends ConsumerState<MyTripScreen> {
  int _tripsCategoryIndex = 0;
  String _tripsStatusFilter = 'All Status';
  String _tripsSearchQuery = '';

  Widget _buildTopBarAvatar() {
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(tripsProvider);
    final allTrips = tripsState.all as List;

    // Category counts are always computed from the FULL list,
    // independent of the status dropdown/search — matches the web
    // app's behavior where tab counts don't shift as you filter.
    final hostingCount = allTrips.where((t) => t.role == 'HOST').length;
    final travellingCount = allTrips.where((t) => t.role == 'GUEST').length;
    final pastCount = allTrips.where(_isPastTrip).length;

    final categories = [
      'All Trips (${allTrips.length})',
      'Hosting ($hostingCount)',
      'Travelling ($travellingCount)',
      'Past ($pastCount)',
    ];

    final filteredTrips = _filterTrips(allTrips);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            DashboardTopBar(
              onNotificationTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              avatarMenu: _buildTopBarAvatar(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
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
              child: RefreshIndicator(
                onRefresh: () => ref.read(tripsProvider.notifier).fetchMyTrips(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchInputField(
                        hint: 'Search route or segment...',
                        onChanged: (value) =>
                            setState(() => _tripsSearchQuery = value),
                      ),
                      const SizedBox(height: 12),
                      StatusFilterDropdown(
                        selectedValue: _tripsStatusFilter,
                        options: const [
                          'All Status',
                          'Upcoming',
                          'Ongoing',
                          'Completed',
                          'Cancelled',
                        ],
                        onChanged: (value) =>
                            setState(() => _tripsStatusFilter = value),
                      ),
                      const SizedBox(height: 16),
                      CategoryChipBar(
                        categories: categories,
                        selectedIndex: _tripsCategoryIndex,
                        onSelected: (index) =>
                            setState(() => _tripsCategoryIndex = index),
                      ),
                      const SizedBox(height: 20),
                      if (tripsState.isLoading)
                        _buildLoadingCard()
                      else if (allTrips.isEmpty)
                        _buildPlaceholderScreen(
                          icon: Icons.alt_route_rounded,
                          title: 'No Trips Yet',
                          subtitle:
                              'Your booked and hosted trips will appear here.',
                          buttonText: 'Post a Trip',
                          onPressed: _openPostTrip,
                        )
                      else if (filteredTrips.isEmpty)
                        _buildPlaceholderScreen(
                          icon: Icons.search_off_rounded,
                          title: 'No matching trips',
                          subtitle: 'Try a different search term or filter.',
                          buttonText: 'Clear Filters',
                          onPressed: () => setState(() {
                            _tripsCategoryIndex = 0;
                            _tripsStatusFilter = 'All Status';
                            _tripsSearchQuery = '';
                          }),
                        )
                      else
                        Column(
                          children: filteredTrips
                              .map<Widget>(
                                (trip) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildTripDetailCardFromTrip(trip),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Future<void> _openPostTrip() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostTripScreen()),
    );
    if (!mounted) return;
    await ref.read(tripsProvider.notifier).fetchMyTrips();
  }

  // ============================================================
  // FILTERING
  // ============================================================

  bool _isPastTrip(dynamic trip) {
    if ((trip.status as String).toUpperCase() == 'COMPLETED') return true;
    final parsed = _parseTripDate(trip.date as String);
    if (parsed == null) return false;
    final today = DateTime.now();
    final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    return dateOnly.isBefore(todayOnly);
  }

  // Handles both ISO dates ("2026-08-04") and display-style dates
  // ("11 Sept 2026") since we don't control the exact format the
  // backend sends in the `date` field on Trip.
  DateTime? _parseTripDate(String raw) {
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;

    const monthAliases = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'sept': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };

    final match = RegExp(r'(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})').firstMatch(raw);
    if (match == null) return null;

    final day = int.tryParse(match.group(1)!);
    final monthKey = match.group(2)!.toLowerCase().substring(
          0,
          match.group(2)!.length >= 4 ? 4 : match.group(2)!.length,
        );
    final month = monthAliases[monthKey] ??
        monthAliases[match.group(2)!.toLowerCase().substring(0, 3)];
    final year = int.tryParse(match.group(3)!);

    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  List<dynamic> _filterTrips(List<dynamic> allTrips) {
    return allTrips.where((trip) {
      switch (_tripsCategoryIndex) {
        case 1: // Hosting
          if (trip.role != 'HOST') return false;
          break;
        case 2: // Travelling
          if (trip.role != 'GUEST') return false;
          break;
        case 3: // Past
          if (!_isPastTrip(trip)) return false;
          break;
        default: // All Trips
          break;
      }

      if (_tripsStatusFilter != 'All Status') {
        final wanted = _tripsStatusFilter.toUpperCase();
        if ((trip.status as String).toUpperCase() != wanted) return false;
      }

      if (_tripsSearchQuery.trim().isNotEmpty) {
        final query = _tripsSearchQuery.trim().toLowerCase();
        if (!(trip.route as String).toLowerCase().contains(query)) return false;
      }

      return true;
    }).toList();
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
        return (bg: const Color(0xffFEE2E2), text: const Color(0xffDC2626));
      case 'ONGOING':
        return (bg: const Color(0xffFEF3C7), text: const Color(0xffB45309));
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
      availabilityLabel: '${trip.seats.booked}/${trip.seats.total} seats filled',
      onDetails: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(tripId: trip.id),
          ),
        );
      },
      onCancel: () => _confirmAndCancelTrip(trip.id, trip.route),
    );
  }

  // ============================================================
  // CANCEL TRIP — confirms with the user first (irreversible,
  // cancels all confirmed bookings too per the backend), then
  // calls the real PUT /trips/:id/cancel endpoint.
  // ============================================================

  Future<void> _confirmAndCancelTrip(String tripId, String route) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this trip?'),
        content: Text(
          'This will cancel "$route" and notify any passengers who already booked. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Trip'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cancel Trip',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final result = await ref.read(tripsProvider.notifier).cancelTrip(tripId);

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Trip cancelled'),
          backgroundColor: result['success'] == true
              ? AppColors.successGreen
              : AppColors.error,
        ),
      );
  }

  Widget _buildPlaceholderScreen({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.lightInputBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryNavy, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonText,
                  style:
                      const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}