import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';

/// Small live preview map for Post Trip — shows markers for whichever of
/// from/to the user has picked so far. Needs no backend call beyond what
/// LocationSearchField already did; this just visualizes the two
/// GeocodeResults the parent screen already holds in state.
class RoutePreviewMap extends StatelessWidget {
  final LatLng? from;
  final LatLng? to;

  const RoutePreviewMap({super.key, this.from, this.to});

  @override
  Widget build(BuildContext context) {
    final points = [?from, ?to];

    if (points.isEmpty) {
      return Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.lightInputBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            'Pick a location to preview the route',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final bounds = points.length == 1
        ? LatLngBounds(points.first, points.first)
        : LatLngBounds.fromPoints(points);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(40),
            ),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.ridesharepro.app',
            ),
            if (from != null && to != null)
              PolylineLayer(
                polylines: [
                  Polyline(points: [from!, to!], strokeWidth: 3, color: AppColors.primaryNavy),
                ],
              ),
            MarkerLayer(
              markers: [
                if (from != null)
                  Marker(
                    point: from!,
                    width: 32,
                    height: 32,
                    child: const Icon(Icons.radio_button_checked,
                        color: AppColors.successGreen, size: 24),
                  ),
                if (to != null)
                  Marker(
                    point: to!,
                    width: 32,
                    height: 32,
                    child: const Icon(Icons.location_on, color: AppColors.error, size: 28),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}