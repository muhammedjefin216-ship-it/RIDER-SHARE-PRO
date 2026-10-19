import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../providers/trips_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/trip_detail_model.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/trip/detail_top_bar.dart';
import '../../widgets/trip/trip_header_card.dart';
import '../../widgets/trip/driver_contact_card.dart';
import '../../widgets/trip/info_grid_tile.dart';
import '../../widgets/trip/route_map_card.dart';
import '../../widgets/trip/waypoint_timeline.dart';
import '../../widgets/trip/inline_notice.dart';
import '../../widgets/trip/trust_badge_chip.dart';
import '../../widgets/buttons/primary_button.dart';

class TripDetailsScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripDetailsScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripsProvider.notifier).fetchTripDetail(widget.tripId);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // Rough estimate only — same placeholder pattern used on the
  // booking/seat-selection screens (no real route/traffic data).
  String _estimatedDrive(double km) {
    if (km <= 0) return '—';
    final minutes = (km / 50 * 60).round();
    if (minutes < 60) return '$minutes mins';
    final hours = minutes ~/ 60;
    final rem = minutes % 60;
    return rem == 0 ? '${hours}h' : '${hours}h ${rem}m';
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(tripsProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            DetailTopBar(
              isFavorited: _isFavorited,
              onFavoriteTap: () => setState(() => _isFavorited = !_isFavorited),
              onShareTap: () => _showMessage('Share isn\'t wired up yet.'),
            ),
            Expanded(
              child: tripsState.isLoadingTripDetail
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNavy))
                  : tripsState.tripDetailError != null
                      ? _buildErrorState(tripsState.tripDetailError!)
                      : tripsState.tripDetail == null
                          ? const SizedBox.shrink()
                          : _buildContent(tripsState.tripDetail!, authState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(tripsProvider.notifier).fetchTripDetail(widget.tripId),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
              child: const Text('Retry', style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TripDetail trip, dynamic authState) {
    final isHost = trip.driver != null && trip.driver!.id == authState.userId;

    // Real route points for the map, built from waypoints (which already
    // include the start and end per Trip.js's pre-save hook) — converts
    // the stored [lng, lat] ordering into flutter_map's LatLng(lat, lng).
    final routePoints = trip.orderedRoutePoints
        .where((w) => w.coordinates.length >= 2)
        .map((w) => LatLng(w.lat, w.lng))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripHeaderCard(
            from: trip.from,
            to: trip.to,
            seatsLeft: trip.seatsAvailable,
            bookedCount: trip.bookedSeatsCount,
            totalEarnings: trip.totalEarnings,
          ),
          const SizedBox(height: 16),

          if (trip.driver != null)
            DriverContactCard(
              avatarText: trip.driver!.avatarInitial,
              verified: trip.driver!.isVerified,
              driverName: trip.driver!.name,
              rating: trip.driver!.rating,
              // "You are the host" replaces the rating line contextually
              // below instead of overloading DriverContactCard's rating
              // row — see the label under the card.
              onMessage: () => _showMessage('Messaging isn\'t wired up yet.'),
              onCall: () => _showMessage('Calling isn\'t wired up yet.'),
            ),
          if (isHost)
            const Padding(
              padding: EdgeInsets.only(top: 6, left: 4),
              child: Text(
                'You are the host',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.successGreen,
                ),
              ),
            ),

          const SizedBox(height: 20),

          const Text('Trip Information',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InfoGridTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'DATE',
                  value: trip.formattedDepartureDate,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InfoGridTile(
                  icon: Icons.access_time,
                  label: 'DEPARTURE',
                  value: trip.departureTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InfoGridTile(
                  icon: Icons.route_outlined,
                  label: 'TOTAL DISTANCE',
                  value: '${trip.totalDistanceKm.toStringAsFixed(2)} km',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InfoGridTile(
                  icon: Icons.event_seat_outlined,
                  label: 'AVAILABILITY',
                  value: '${trip.seatsAvailable} seats left',
                  highlighted: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          RouteMapCard(
            distanceLabel: '${trip.totalDistanceKm.toStringAsFixed(2)} km',
            distanceKm: trip.totalDistanceKm,
            estimatedDriveLabel: _estimatedDrive(trip.totalDistanceKm),
            routePoints: routePoints,
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Route Details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 14),
                WaypointTimeline(
                  stops: [
                    for (var i = 0; i < trip.waypoints.length; i++)
                      WaypointStop(
                        name: trip.waypoints[i].name,
                        subLabel: i == 0
                            ? 'Departure • ${trip.departureTime}'
                            : i == trip.waypoints.length - 1
                                ? 'Destination'
                                : 'Stop',
                        isFirst: i == 0,
                        isLast: i == trip.waypoints.length - 1,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                InlineNotice(
                  icon: Icons.bolt_rounded,
                  message: 'Allows up to ${trip.maxDetourKm.toStringAsFixed(0)} km detour for pickups',
                  backgroundColor: AppColors.infoBannerBg,
                  borderColor: AppColors.infoBannerBg,
                  iconColor: AppColors.primaryNavy,
                  textColor: AppColors.primaryNavy,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // NOTE: Figma also shows amenity chips (AC, Music System, USB
          // Charging, Luggage Space, No Pets, No Smoking). There's no
          // amenities field on the Trip schema — vehicleInfo is a single
          // plain string — so those are left out rather than faked.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Vehicle',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.lightInputBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.directions_car, color: AppColors.primaryNavy, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        trip.vehicleInfo.isNotEmpty ? trip.vehicleInfo : 'Vehicle details not provided',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Trip Summary',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _summaryRow('Price per Seat', '₹${trip.pricePerSeat.toInt()}'),
                const SizedBox(height: 8),
                _summaryRow('Total Seats', '${trip.totalSeats}'),
                const SizedBox(height: 8),
                _summaryRow('Confirmed Bookings', '${trip.confirmedBookingsCount}'),
                const Divider(height: 24),
                _summaryRow(
                  'Total Earnings',
                  '₹${trip.totalEarnings.toInt()}',
                  isTotal: true,
                  subtitle: trip.confirmedBookingsCount == 0 ? 'No bookings yet' : null,
                ),
                const SizedBox(height: 14),
                const TrustBadgeChip(
                  icon: Icons.shield_outlined,
                  label: 'Secured by Stripe Escrow — Funds held safely until trip completes',
                  backgroundColor: AppColors.hostingTagBg,
                  contentColor: AppColors.successGreen,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => _showMessage('Edit Trip screen isn\'t built yet.'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Edit Trip',
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: PrimaryButton(
                  label: 'Back to My trips',
                  trailingIcon: Icons.arrow_forward_rounded,
                  height: 48,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false, String? subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value,
                style: TextStyle(
                  fontSize: isTotal ? 20 : 13,
                  fontWeight: FontWeight.bold,
                  color: isTotal ? AppColors.successGreen : AppColors.textPrimary,
                )),
            if (subtitle != null)
              Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.hintText)),
          ],
        ),
      ],
    );
  }
}