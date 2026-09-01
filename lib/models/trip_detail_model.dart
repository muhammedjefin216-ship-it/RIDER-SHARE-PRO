// ============================================================
// TripDetail — matches the RAW Trip Mongoose document returned by
// GET /api/trips/:id (tripController.js -> getTripById), which
// does `res.json({ success: true, data: trip })` with no
// reformatting. Field names here mirror models/Trip.js exactly.
// ============================================================

class TripWaypoint {
  final String name;
  final double distanceFromStart;
  final int order;

  TripWaypoint({required this.name, required this.distanceFromStart, required this.order});

  factory TripWaypoint.fromJson(Map<String, dynamic> json) {
    return TripWaypoint(
      name: (json['name'] ?? '').toString(),
      distanceFromStart: (json['distanceFromStart'] as num?)?.toDouble() ?? 0.0,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

class SeatBookingEntry {
  final String? bookingId;
  final int fromOrder;
  final int toOrder;
  final String status; // "confirmed" | "cancelled"

  SeatBookingEntry({
    required this.bookingId,
    required this.fromOrder,
    required this.toOrder,
    required this.status,
  });

  factory SeatBookingEntry.fromJson(Map<String, dynamic> json) {
    return SeatBookingEntry(
      bookingId: json['bookingId']?.toString(),
      fromOrder: (json['fromOrder'] as num?)?.toInt() ?? 0,
      toOrder: (json['toOrder'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? 'confirmed').toString(),
    );
  }
}

class TripSeatEntry {
  final int seatNumber;
  final List<SeatBookingEntry> bookings;

  TripSeatEntry({required this.seatNumber, required this.bookings});

  factory TripSeatEntry.fromJson(Map<String, dynamic> json) {
    final rawBookings = (json['bookings'] as List?) ?? [];
    return TripSeatEntry(
      seatNumber: (json['seatNumber'] as num?)?.toInt() ?? 0,
      bookings: rawBookings
          .map((e) => SeatBookingEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TripDriver {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final double rating;
  final String? profilePhoto;
  final bool isVerified;
  final DateTime? memberSince;

  TripDriver({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.rating,
    this.profilePhoto,
    required this.isVerified,
    this.memberSince,
  });

  String get avatarInitial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  factory TripDriver.fromJson(Map<String, dynamic> json) {
    return TripDriver(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      profilePhoto: json['profilePhoto']?.toString(),
      isVerified: json['isVerified'] == true,
      memberSince:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}

class TripDetail {
  final String id;
  final String from;
  final String to;
  final List<TripWaypoint> waypoints;
  final String departureDate; // raw string, e.g. "2026-08-04"
  final String departureTime;
  final List<TripSeatEntry> seats;
  final int totalSeats;
  final double pricePerSeat;
  final double maxDetourKm;
  final bool womenOnly;
  final String status; // upcoming | ongoing | completed | cancelled
  final double totalDistanceKm;
  final double farePerKm;
  final int seatsAvailable;
  final String vehicleInfo;
  final TripDriver? driver;

  TripDetail({
    required this.id,
    required this.from,
    required this.to,
    required this.waypoints,
    required this.departureDate,
    required this.departureTime,
    required this.seats,
    required this.totalSeats,
    required this.pricePerSeat,
    required this.maxDetourKm,
    required this.womenOnly,
    required this.status,
    required this.totalDistanceKm,
    required this.farePerKm,
    required this.seatsAvailable,
    required this.vehicleInfo,
    this.driver,
  });

  factory TripDetail.fromJson(Map<String, dynamic> json) {
    final rawWaypoints = (json['waypoints'] as List?) ?? [];
    final rawSeats = (json['seats'] as List?) ?? [];
    final rawDriver = json['driverId'];

    return TripDetail(
      id: (json['_id'] ?? '').toString(),
      from: (json['from'] ?? '').toString(),
      to: (json['to'] ?? '').toString(),
      waypoints:
          rawWaypoints.map((e) => TripWaypoint.fromJson(e as Map<String, dynamic>)).toList(),
      departureDate: (json['departureDate'] ?? '').toString(),
      departureTime: (json['departureTime'] ?? '').toString(),
      seats: rawSeats.map((e) => TripSeatEntry.fromJson(e as Map<String, dynamic>)).toList(),
      totalSeats: (json['totalSeats'] as num?)?.toInt() ?? 0,
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble() ?? 0.0,
      maxDetourKm: (json['maxDetourKm'] as num?)?.toDouble() ?? 10.0,
      womenOnly: json['womenOnly'] == true,
      status: (json['status'] ?? 'upcoming').toString(),
      totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble() ?? 0.0,
      farePerKm: (json['farePerKm'] as num?)?.toDouble() ?? 0.0,
      seatsAvailable: (json['seatsAvailable'] as num?)?.toInt() ?? 0,
      vehicleInfo: (json['vehicleInfo'] ?? '').toString(),
      driver: rawDriver is Map<String, dynamic> ? TripDriver.fromJson(rawDriver) : null,
    );
  }

  // Formats the raw departureDate string (e.g. "2026-08-04") into
  // "4 Aug 2026" for display. Falls back to the raw string if it
  // doesn't parse as a date.
  String get formattedDepartureDate {
    final parsed = DateTime.tryParse(departureDate);
    if (parsed == null) return departureDate;

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
  }

  // ============================================================
  // COMPUTED — getTripById returns the raw document with no
  // pre-computed convenience fields, so these replicate the exact
  // same formula tripController.js -> getMyTrips uses, for
  // consistency across the app.
  // ============================================================

  int get confirmedBookingsCount {
    final seenBookingIds = <String>{};
    var countWithoutId = 0;

    for (final seat in seats) {
      for (final booking in seat.bookings) {
        if (booking.status != 'confirmed') continue;
        if (booking.bookingId != null) {
          seenBookingIds.add(booking.bookingId!);
        } else {
          countWithoutId++;
        }
      }
    }

    return seenBookingIds.length + countWithoutId;
  }

  double _distanceAt(int order) {
    for (final w in waypoints) {
      if (w.order == order) return w.distanceFromStart;
    }
    return 0.0;
  }

  double get totalEarnings {
    double total = 0;
    for (final seat in seats) {
      for (final booking in seat.bookings) {
        if (booking.status != 'confirmed') continue;
        final dist = _distanceAt(booking.toOrder) - _distanceAt(booking.fromOrder);
        total += (((farePerKm * dist) / 10).round() * 10);
      }
    }
    return total;
  }

  int get bookedSeatsCount => totalSeats - seatsAvailable;
}