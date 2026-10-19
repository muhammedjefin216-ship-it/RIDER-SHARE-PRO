import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'dio_client.dart';

class NotificationService {
  Future<Dio> get _dio async => await DioClient.getInstance();

  // GET /api/notifications -> { success, data: [...], unreadCount }
  Future<Response> getNotifications() async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiConstants.notifications);
      return response;
    } on DioException catch (e) {
      print('GET NOTIFICATIONS ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // PUT /api/notifications/:id/read
  Future<Response> markAsRead(String notificationId) async {
    try {
      final dio = await _dio;
      final response = await dio.put(
        ApiConstants.markNotificationRead(notificationId),
      );
      return response;
    } on DioException catch (e) {
      print('MARK NOTIFICATION READ ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // PUT /api/notifications/read-all
  Future<Response> markAllAsRead() async {
    try {
      final dio = await _dio;
      final response = await dio.put(ApiConstants.markAllNotificationsRead);
      return response;
    } on DioException catch (e) {
      print('MARK ALL NOTIFICATIONS READ ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }
}