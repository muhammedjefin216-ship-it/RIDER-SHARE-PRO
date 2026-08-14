import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharepro/services/trip_service.dart';

import '../models/trip_model.dart';

class TripsState {
  final bool isLoading;
  final bool isPosting;
  final List<Trip> hosted;
  final List<Trip> guest;
  final List<Trip> all;
  final String? errorMessage;

  const TripsState({
    this.isLoading = false,
    this.isPosting = false,
    this.hosted = const [],
    this.guest = const [],
    this.all = const [],
    this.errorMessage,
  });

  TripsState copyWith({
    bool? isLoading,
    bool? isPosting,
    List<Trip>? hosted,
    List<Trip>? guest,
    List<Trip>? all,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TripsState(
      isLoading: isLoading ?? this.isLoading,
      isPosting: isPosting ?? this.isPosting,
      hosted: hosted ?? this.hosted,
      guest: guest ?? this.guest,
      all: all ?? this.all,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
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
}
