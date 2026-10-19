import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/geocode_model.dart';
import 'dio_client.dart';

class GeocodeService {
  Future<Dio> get _dio async => await DioClient.getInstance();

  // GET /api/geocode/search?q=... -> raw Nominatim array (or [] on error/
  // too-short query — geocodeRoutes.js always returns 200 with an array,
  // never throws, so there's no DioException path to handle for a "no
  // results" case specifically, only real network failures).
  Future<List<GeocodeResult>> search(String query) async {
    if (query.trim().length < 2) return [];

    try {
      final dio = await _dio;
      final response = await dio.get(ApiConstants.geocodeSearch(query.trim()));
      final rawList = response.data as List? ?? [];
      return rawList
          .map((e) => GeocodeResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      print('GEOCODE SEARCH ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      return [];
    }
  }
}