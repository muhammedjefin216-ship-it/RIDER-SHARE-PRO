import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'dio_client.dart';

class TripsService {
  Future<Dio> get _dio async => await DioClient.getInstance();

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
}
