// ============================================================
// Trip model — matches the exact shape returned by
// GET /api/trips/my-trips/all (tripController.js -> getMyTrips)
//
// Each item in data.all (combining hosted + guest trips) looks
// like:
// {
//   id, tripId, route, role ("HOST" | "GUEST"),
//   date, time, status ("UPCOMING" | "ONGOING" | "COMPLETED" | "CANCELLED"),
//   seats: { booked, total },
//   amount (already formatted as a string, e.g. "₹500")
// }
// ============================================================

class TripSeats {
  final int booked;
  final int total;

  TripSeats({required this.booked, required this.total});

  factory TripSeats.fromJson(Map<String, dynamic>? json) {
    return TripSeats(
      booked: (json?['booked'] as num?)?.toInt() ?? 0,
      total: (json?['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class Trip {
  final String id;
  final String tripId;
  final String route;
  final String role; // "HOST" or "GUEST"
  final String date;
  final String time;
  final String status; // "UPCOMING" | "ONGOING" | "COMPLETED" | "CANCELLED"
  final String amount; // already formatted, e.g. "₹500"
  final TripSeats seats;

  Trip({
    required this.id,
    required this.tripId,
    required this.route,
    required this.role,
    required this.date,
    required this.time,
    required this.status,
    required this.amount,
    required this.seats,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: (json['id'] ?? '').toString(),
      tripId: (json['tripId'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      amount: (json['amount'] ?? '').toString(),
      seats: TripSeats.fromJson(json['seats'] as Map<String, dynamic>?),
    );
  }
}