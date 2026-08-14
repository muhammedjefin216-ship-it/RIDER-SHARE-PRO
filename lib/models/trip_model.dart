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
  final String role;
  final String date;
  final String time;
  final String status;
  final String amount;
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
