import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'dio_client.dart';

class MessageService {
  Future<Dio> get _dio async => await DioClient.getInstance();

  // GET /api/messages -> list of conversations
  Future<Response> getConversations() async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiConstants.conversations);
      return response;
    } on DioException catch (e) {
      print('GET CONVERSATIONS ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // GET /api/messages/unread -> { data: { unreadCount } }
  Future<Response> getUnreadCount() async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiConstants.unreadMessagesCount);
      return response;
    } on DioException catch (e) {
      print('GET UNREAD MESSAGE COUNT ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // GET /api/messages/:bookingId -> REST fallback for history
  // (ChatScreen normally uses the socket's join_chat event instead, since
  // that also joins the live room in one round trip — this REST route is
  // kept available in case a non-chat screen ever needs history without
  // opening a socket connection.)
  Future<Response> getMessageHistory(String bookingId) async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiConstants.messageHistory(bookingId));
      return response;
    } on DioException catch (e) {
      print('GET MESSAGE HISTORY ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // POST /api/quick-replies -> { data: { replies: [...] } }
  // Pass the OTHER person's most recent message text; the backend does
  // simple keyword matching against it to suggest replies for this user.
  Future<Response> getQuickReplies(String lastMessageText) async {
    try {
      final dio = await _dio;
      final response = await dio.post(
        ApiConstants.quickReplies,
        data: {'message': lastMessageText},
      );
      return response;
    } on DioException catch (e) {
      print('GET QUICK REPLIES ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }
}