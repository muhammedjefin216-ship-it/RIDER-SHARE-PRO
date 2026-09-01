import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'dio_client.dart';

class PaymentService {
  Future<Dio> get _dio async => await DioClient.getInstance();

  Future<Response> createPaymentIntent({
    required String tripId,
    required int fromOrder,
    required int toOrder,
    required List<int> seatNumbers,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.createPaymentIntent,
        data: {
          'tripId': tripId,
          'fromOrder': fromOrder,
          'toOrder': toOrder,
          'seatNumbers': seatNumbers,
        },
      );

      return response;
    } on DioException catch (e) {
      print('CREATE PAYMENT INTENT ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }
}