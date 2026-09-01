import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharepro/services/trip_service.dart';

import '../models/trip_model.dart';
import '../models/trip_detail_model.dart';

// ============================================================
// SEAT MAP ENTRY — matches tripController.js -> getSeatMap exactly:
// { seatNumber, available, occupiedBy: {fromOrder,toOrder}|null }
// ============================================================
class SeatMapEntry {
  final int seatNumber;
  final bool available;

  SeatMapEntry({required this.seatNumber, required this.available});

  factory SeatMapEntry.fromJson(Map<String, dynamic> json) {
    return SeatMapEntry(
      seatNumber: (json['seatNumber'] as num?)?.toInt() ?? 0,
      available: json['available'] == true,
    );
  }
}

class TripsState {
  final bool isLoading;
  final bool isPosting;
  final List<Trip> hosted;
  final List<Trip> guest;
  final List<Trip> all;
  final String? errorMessage;

  // Seat map + booking state.
  final bool isLoadingSeatMap;
  final List<SeatMapEntry> seatMap;
  final num? segmentFare;
  final double? segmentDistanceKm;
  final String? seatMapError;
  final bool isBooking;
  final String? bookingError;

  // Trip details state.
  final bool isLoadingTripDetail;
  final TripDetail? tripDetail;
  final String? tripDetailError;

  const TripsState({
    this.isLoading = false,
    this.isPosting = false,
    this.hosted = const [],
    this.guest = const [],
    this.all = const [],
    this.errorMessage,
    this.isLoadingSeatMap = false,
    this.seatMap = const [],
    this.segmentFare,
    this.segmentDistanceKm,
    this.seatMapError,
    this.isBooking = false,
    this.bookingError,
    this.isLoadingTripDetail = false,
    this.tripDetail,
    this.tripDetailError,
  });

  TripsState copyWith({
    bool? isLoading,
    bool? isPosting,
    List<Trip>? hosted,
    List<Trip>? guest,
    List<Trip>? all,
    String? errorMessage,
    bool clearError = false,
    bool? isLoadingSeatMap,
    List<SeatMapEntry>? seatMap,
    num? segmentFare,
    double? segmentDistanceKm,
    String? seatMapError,
    bool clearSeatMapError = false,
    bool? isBooking,
    String? bookingError,
    bool clearBookingError = false,
    bool? isLoadingTripDetail,
    TripDetail? tripDetail,
    String? tripDetailError,
    bool clearTripDetailError = false,
  }) {
    return TripsState(
      isLoading: isLoading ?? this.isLoading,
      isPosting: isPosting ?? this.isPosting,
      hosted: hosted ?? this.hosted,
      guest: guest ?? this.guest,
      all: all ?? this.all,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLoadingSeatMap: isLoadingSeatMap ?? this.isLoadingSeatMap,
      seatMap: seatMap ?? this.seatMap,
      segmentFare: segmentFare ?? this.segmentFare,
      segmentDistanceKm: segmentDistanceKm ?? this.segmentDistanceKm,
      seatMapError: clearSeatMapError ? null : seatMapError ?? this.seatMapError,
      isBooking: isBooking ?? this.isBooking,
      bookingError: clearBookingError ? null : bookingError ?? this.bookingError,
      isLoadingTripDetail: isLoadingTripDetail ?? this.isLoadingTripDetail,
      tripDetail: tripDetail ?? this.tripDetail,
      tripDetailError: clearTripDetailError ? null : tripDetailError ?? this.tripDetailError,
    );
  }
}

final tripsProvider = NotifierProvider<TripsNotifier, TripsState>(
  TripsNotifier.new,
);

class TripsNotifier extends Notifier<TripsState> {
  final TripsService _tripsService = TripsService();

  @override
  TripsState build() {
    return const TripsState();
  }

  // ============================================================
  // CREATE TRIP (Host a Ride)
  // ============================================================

  Future<Map<String, dynamic>> createTrip({
    required String from,
    required String to,
    required double fromLat,
    required double fromLon,
    required double toLat,
    required double toLon,
    required String departureDate,
    required String departureTime,
    required int totalSeats,
    required double pricePerSeat,
    double? maxDetourKm,
    bool womenOnly = false,
    String vehicleInfo = '',
  }) async {
    state = state.copyWith(isPosting: true, clearError: true);

    try {
      final response = await _tripsService.createTrip(
        from: from,
        to: to,
        fromLat: fromLat,
        fromLon: fromLon,
        toLat: toLat,
        toLon: toLon,
        departureDate: departureDate,
        departureTime: departureTime,
        totalSeats: totalSeats,
        pricePerSeat: pricePerSeat,
        maxDetourKm: maxDetourKm,
        womenOnly: womenOnly,
        vehicleInfo: vehicleInfo,
      );

      state = state.copyWith(isPosting: false, clearError: true);

      // Refresh the trips list so the new trip shows up right away.
      await fetchMyTrips();

      return {
        'success': true,
        'message': response.data['message'] ?? 'Trip posted successfully',
      };
    } on DioException catch (e) {
      String message = 'Unable to post trip';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      state = state.copyWith(isPosting: false, errorMessage: message);
      return {'success': false, 'message': message};
    } catch (e) {
      state = state.copyWith(isPosting: false, errorMessage: e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> fetchMyTrips() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _tripsService.getMyTrips();
      final data = response.data['data'] as Map<String, dynamic>?;

      final hosted = ((data?['hosted'] as List?) ?? [])
          .map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList();

      final guest = ((data?['guest'] as List?) ?? [])
          .map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList();

      final all = ((data?['all'] as List?) ?? [])
          .map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        isLoading: false,
        hosted: hosted,
        guest: guest,
        all: all,
        clearError: true,
      );
    } on DioException catch (e) {
      print('FETCH MY TRIPS ERROR: ${e.response?.data}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load trips',
      );
    } catch (e) {
      print('FETCH MY TRIPS UNKNOWN ERROR: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // ============================================================
  // GET SEAT MAP — matches tripController.js -> getSeatMap.
  // Requires fromOrder/toOrder (the segment being booked), not
  // just the trip ID.
  // ============================================================

  Future<bool> fetchSeatMap({
    required String tripId,
    required int fromOrder,
    required int toOrder,
  }) async {
    state = state.copyWith(isLoadingSeatMap: true, clearSeatMapError: true);

    try {
      final response = await _tripsService.getSeatMap(
        tripId: tripId,
        fromOrder: fromOrder,
        toOrder: toOrder,
      );
      final data = response.data['data'] as Map<String, dynamic>?;
      final rawSeats = (data?['seatMap'] as List?) ?? [];

      final seats = rawSeats
          .map((e) => SeatMapEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        isLoadingSeatMap: false,
        seatMap: seats,
        segmentFare: data?['fare'] as num?,
        segmentDistanceKm: (data?['distanceKm'] as num?)?.toDouble(),
        clearSeatMapError: true,
      );
      return true;
    } on DioException catch (e) {
      print('GET SEAT MAP ERROR: ${e.response?.data}');
      state = state.copyWith(
        isLoadingSeatMap: false,
        seatMapError: 'Unable to load seat map',
      );
      return false;
    } catch (e) {
      print('GET SEAT MAP UNKNOWN ERROR: $e');
      state = state.copyWith(isLoadingSeatMap: false, seatMapError: e.toString());
      return false;
    }
  }

  // ============================================================
  // BOOK A TRIP SEGMENT — matches tripController.js -> bookSegment.
  //
  // IMPORTANT: the backend requires a real, already-verified Stripe
  // paymentIntentId and will reject the request with 400
  // ("Payment required to book seats") without one. Only call this
  // AFTER a successful Stripe payment — not right after seat
  // selection.
  // ============================================================

  Future<Map<String, dynamic>> bookTrip({
    required String tripId,
    required int fromOrder,
    required int toOrder,
    required List<int> seatNumbers,
    required String paymentIntentId,
  }) async {
    state = state.copyWith(isBooking: true, clearBookingError: true);

    try {
      final response = await _tripsService.bookTrip(
        tripId: tripId,
        fromOrder: fromOrder,
        toOrder: toOrder,
        seatNumbers: seatNumbers,
        paymentIntentId: paymentIntentId,
      );

      state = state.copyWith(isBooking: false, clearBookingError: true);

      return {
        'success': true,
        'message': response.data['message'] ?? 'Booking confirmed',
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      String message = 'Unable to book this trip';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      state = state.copyWith(isBooking: false, bookingError: message);
      return {'success': false, 'message': message};
    } catch (e) {
      state = state.copyWith(isBooking: false, bookingError: e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================================
  // GET TRIP DETAILS — matches tripController.js -> getTripById.
  // ============================================================

  Future<bool> fetchTripDetail(String tripId) async {
    state = state.copyWith(isLoadingTripDetail: true, clearTripDetailError: true);

    try {
      final response = await _tripsService.getTripDetails(tripId: tripId);
      final data = response.data['data'] as Map<String, dynamic>?;

      if (data == null) {
        state = state.copyWith(
          isLoadingTripDetail: false,
          tripDetailError: 'Trip data was empty',
        );
        return false;
      }

      final detail = TripDetail.fromJson(data);

      state = state.copyWith(
        isLoadingTripDetail: false,
        tripDetail: detail,
        clearTripDetailError: true,
      );
      return true;
    } on DioException catch (e) {
      String message = 'Unable to load trip details';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      print('GET TRIP DETAIL ERROR: ${e.response?.data}');
      state = state.copyWith(isLoadingTripDetail: false, tripDetailError: message);
      return false;
    } catch (e) {
      print('GET TRIP DETAIL UNKNOWN ERROR: $e');
      state = state.copyWith(isLoadingTripDetail: false, tripDetailError: e.toString());
      return false;
    }
  }
}