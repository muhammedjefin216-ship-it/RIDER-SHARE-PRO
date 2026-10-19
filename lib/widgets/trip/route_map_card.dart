import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';

/// Real route map using flutter_map + OpenStreetMap tiles (no API key —
/// matches the backend's Nominatim-based geocoding setup). Replaces the
/// previous placeholder version of this card, which only showed distance
/// text with no actual map.
///
/// NOTE: I don't have the original route_map_card.dart source (it was
/// never shared), so this is a full rewrite based on the only known
/// call site (trip_details_screen.dart passing distanceLabel, distanceKm,
/// estimatedDriveLabel). If this card is used anywhere else with a
/// different constructor shape, that call site will need updating to
/// match this one.
class RouteMapCard extends StatelessWidget {
  final String distanceLabel;
  final double distanceKm;
  final String estimatedDriveLabel;
  // Ordered list of route points (start -> intermediate stops -> end).
  // Pass trip.orderedRoutePoints.map((w) => LatLng(w.lat, w.lng)).toList()
  final List<LatLng> routePoints;

  const RouteMapCard({
    super.key,
    required this.distanceLabel,
    required this.distanceKm,
    required this.estimatedDriveLabel,
    required this.routePoints,
  });

  LatLngBounds? get _bounds {
    if (routePoints.isEmpty) return null;
    if (routePoints.length == 1) {
      return LatLngBounds(routePoints.first, routePoints.first);
    }
    return LatLngBounds.fromPoints(routePoints);
  }

  @override
  Widget build(BuildContext context) {
    final bounds = _bounds;
    final hasRoute = routePoints.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: !hasRoute
                ? Container(
                    color: AppColors.lightInputBg,
                    child: const Center(
                      child: Text(
                        'Route location unavailable',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : FlutterMap(
                    options: MapOptions(
                      initialCameraFit: bounds != null
                          ? CameraFit.bounds(
                              bounds: bounds,
                              padding: const EdgeInsets.all(40),
                            )
                          : null,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.ridesharepro.app',
                      ),
                      if (routePoints.length >= 2)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              strokeWidth: 4,
                              color: AppColors.primaryNavy,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: routePoints.first,
                            width: 36,
                            height: 36,
                            child: const Icon(
                              Icons.radio_button_checked,
                              color: AppColors.successGreen,
                              size: 28,
                            ),
                          ),
                          if (routePoints.length > 1)
                            Marker(
                              point: routePoints.last,
                              width: 36,
                              height: 36,
                              child: const Icon(
                                Icons.location_on,
                                color: AppColors.error,
                                size: 32,
                              ),
                            ),
                          // Intermediate stops, if any.
                          for (final point in routePoints.sublist(
                            1,
                            routePoints.length > 1 ? routePoints.length - 1 : 1,
                          ))
                            Marker(
                              point: point,
                              width: 20,
                              height: 20,
                              child: const Icon(
                                Icons.circle,
                                color: AppColors.primaryNavy,
                                size: 12,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statItem(Icons.route_outlined, distanceLabel, 'Distance'),
                Container(width: 1, height: 28, color: AppColors.border),
                _statItem(Icons.schedule_outlined, estimatedDriveLabel, 'Est. drive'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryNavy),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}