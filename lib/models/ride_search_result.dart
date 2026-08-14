class RideSearchResult {
  final String id;
  final String driver;
  final String avatar;
  final double rating;
  final bool verified;
  final String from;
  final String to;
  final String fullFrom;
  final String fullTo;
  final String departTime;
  final String departureDate;
  final num price;
  final num fullPrice;
  final int seatsLeft;
  final int totalSeats;
  final double distanceKm;
  final String vehicleInfo;
  final bool womenOnly;
  final int fromOrder;
  final int toOrder;

  RideSearchResult({
    required this.id,
    required this.driver,
    required this.avatar,
    required this.rating,
    required this.verified,
    required this.from,
    required this.to,
    required this.fullFrom,
    required this.fullTo,
    required this.departTime,
    required this.departureDate,
    required this.price,
    required this.fullPrice,
    required this.seatsLeft,
    required this.totalSeats,
    required this.distanceKm,
    required this.vehicleInfo,
    required this.womenOnly,
    required this.fromOrder,
    required this.toOrder,
  });

  factory RideSearchResult.fromJson(Map<String, dynamic> json) {
    return RideSearchResult(
      id: (json['id'] ?? '').toString(),
      driver: (json['driver'] ?? 'Unknown').toString(),
      avatar: (json['avatar'] ?? '?').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      verified: json['verified'] == true,
      from: (json['from'] ?? '').toString(),
      to: (json['to'] ?? '').toString(),
      fullFrom: (json['fullFrom'] ?? '').toString(),
      fullTo: (json['fullTo'] ?? '').toString(),
      departTime: (json['departTime'] ?? '').toString(),
      departureDate: (json['departureDate'] ?? '').toString(),
      price: (json['price'] as num?) ?? 0,
      fullPrice: (json['fullPrice'] as num?) ?? 0,
      seatsLeft: (json['seatsLeft'] as num?)?.toInt() ?? 0,
      totalSeats: (json['totalSeats'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      vehicleInfo: (json['vehicleInfo'] ?? '').toString(),
      womenOnly: json['womenOnly'] == true,
      fromOrder: (json['fromOrder'] as num?)?.toInt() ?? 0,
      toOrder: (json['toOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
