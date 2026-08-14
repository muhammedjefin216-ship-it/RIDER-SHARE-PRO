import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharepro/services/trip_service.dart';
import '../models/ride_search_result.dart';

class RideSearchState {
  final bool isSearching;
  final bool hasSearched;
  final List<RideSearchResult> results;
  final String? errorMessage;

  const RideSearchState({
    this.isSearching = false,
    this.hasSearched = false,
    this.results = const [],
    this.errorMessage,
  });

  RideSearchState copyWith({
    bool? isSearching,
    bool? hasSearched,
    List<RideSearchResult>? results,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RideSearchState(
      isSearching: isSearching ?? this.isSearching,
      hasSearched: hasSearched ?? this.hasSearched,
      results: results ?? this.results,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final rideSearchProvider =
    NotifierProvider<RideSearchNotifier, RideSearchState>(
  RideSearchNotifier.new,
);

class RideSearchNotifier extends Notifier<RideSearchState> {
  final TripsService _tripsService = TripsService();

  @override
  RideSearchState build() {
    return const RideSearchState();
  }

  Future<void> search({
    required String from,
    required String to,
    String? date,
    int passengers = 1,
    bool? womenOnly,
    num? maxPrice,
  }) async {
    state = state.copyWith(isSearching: true, clearError: true);

    try {
      final response = await _tripsService.searchTrips(
        from: from,
        to: to,
        date: date,
        passengers: passengers,
        womenOnly: womenOnly,
        maxPrice: maxPrice,
      );

      final rawList = (response.data['data'] as List?) ?? [];
      final results = rawList
          .map((e) => RideSearchResult.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        isSearching: false,
        hasSearched: true,
        results: results,
        clearError: true,
      );
    } on DioException catch (e) {
      String message = 'Unable to search rides';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      state = state.copyWith(
        isSearching: false,
        hasSearched: true,
        errorMessage: message,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        hasSearched: true,
        errorMessage: e.toString(),
      );
    }
  }
}