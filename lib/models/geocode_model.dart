// Matches Nominatim's raw JSON array shape exactly, as proxied verbatim
// by geocodeRoutes.js (it returns response.data straight through, or []
// on any error — never a 500, per that file's design).

class GeocodeResult {
  final double lat;
  final double lon;
  final String displayName;

  GeocodeResult({
    required this.lat,
    required this.lon,
    required this.displayName,
  });

  factory GeocodeResult.fromJson(Map<String, dynamic> json) {
    return GeocodeResult(
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0.0,
      lon: double.tryParse(json['lon']?.toString() ?? '') ?? 0.0,
      displayName: (json['display_name'] ?? '').toString(),
    );
  }
}