import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'dio_client.dart';

class TripsService {
  Future<Dio> get _dio async => await DioClient.getInstance();

  // ============================================================
  // CREATE TRIP (Host a Ride)
  // ============================================================

  Future<Response> createTrip({
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
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.createTrip,
        data: {
          'from': from,
          'to': to,
          'fromLat': fromLat,
          'fromLon': fromLon,
          'toLat': toLat,
          'toLon': toLon,
          'departureDate': departureDate,
          'departureTime': departureTime,
          'totalSeats': totalSeats,
          'pricePerSeat': pricePerSeat,
          if (maxDetourKm != null) 'maxDetourKm': maxDetourKm,
          'womenOnly': womenOnly,
          'vehicleInfo': vehicleInfo,
        },
      );

      return response;
    } on DioException catch (e) {
      print('CREATE TRIP ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // SEARCH TRIPS
  // ============================================================

  Future<Response> searchTrips({
    required String from,
    required String to,
    String? date,
    int passengers = 1,
    bool? womenOnly,
    num? maxPrice,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.get(
        ApiConstants.searchTrips,
        queryParameters: {
          'from': from,
          'to': to,
          if (date != null) 'date': date,
          'passengers': passengers,
          if (womenOnly != null) 'womenOnly': womenOnly.toString(),
          if (maxPrice != null) 'maxPrice': maxPrice,
        },
      );

      return response;
    } on DioException catch (e) {
      print('SEARCH TRIPS ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // GET MY TRIPS (hosted by current user)
  // ============================================================

  Future<Response> getMyTrips() async {
    try {
      final dio = await _dio;

      final response = await dio.get(ApiConstants.myTrips);

      return response;
    } on DioException catch (e) {
      print('GET MY TRIPS ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // GET SEAT MAP (real-time seat availability for a segment)
  //
  // Matches tripController.js -> getSeatMap exactly:
  // GET /trips/:id/seat-map?fromOrder=X&toOrder=Y
  // ============================================================

  Future<Response> getSeatMap({
    required String tripId,
    required int fromOrder,
    required int toOrder,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.get(
        ApiConstants.seatMap(tripId),
        queryParameters: {
          'fromOrder': fromOrder,
          'toOrder': toOrder,
        },
      );

      return response;
    } on DioException catch (e) {
      print('GET SEAT MAP ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // BOOK A TRIP SEGMENT (waypoint-to-waypoint)
  //
  // Matches tripController.js -> bookSegment exactly. Requires a
  // real Stripe paymentIntentId — the backend calls verifyPayment()
  // and rejects the request with 400 ("Payment required to book
  // seats") if it's missing, so this must only be called AFTER a
  // successful Stripe payment on the Flutter side.
  // ============================================================

  Future<Response> bookTrip({
    required String tripId,
    required int fromOrder,
    required int toOrder,
    required List<int> seatNumbers,
    required String paymentIntentId,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.bookTrip(tripId),
        data: {
          'fromOrder': fromOrder,
          'toOrder': toOrder,
          'seatNumbers': seatNumbers,
          'paymentIntentId': paymentIntentId,
        },
      );

      return response;
    } on DioException catch (e) {
      print('BOOK TRIP ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // GET TRIP DETAILS — matches tripController.js -> getTripById.
  // Returns the RAW Trip document, not a reformatted shape.
  // ============================================================

  Future<Response> getTripDetails({required String tripId}) async {
    try {
      final dio = await _dio;

      final response = await dio.get(ApiConstants.tripDetails(tripId));

      return response;
    } on DioException catch (e) {
      print('GET TRIP DETAILS ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }
}