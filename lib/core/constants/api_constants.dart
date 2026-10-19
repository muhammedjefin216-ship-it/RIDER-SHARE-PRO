class ApiConstants {
  static const String baseUrl = 'https://api.rideshareproapp.com/api';

  static const String register = '$baseUrl/auth/register';

  static const String login = '$baseUrl/auth/login';

  static const String google = '$baseUrl/auth/google';

  static const String refreshToken = '$baseUrl/auth/refresh-token';

  static const String searchTrips = '$baseUrl/trips/search';

  static const String myTrips = '$baseUrl/trips/my-trips/all';

  static const String createTrip = '$baseUrl/trips';

  static const String verifyEmail = '$baseUrl/auth/verify-email';

  static const String resendOtp = '$baseUrl/auth/resend-otp';

  static const String forgotPassword = '$baseUrl/auth/forgot-password';

  static const String verifyForgotOtp = '$baseUrl/auth/verify-forgot-otp';

  static const String resetPassword = '$baseUrl/auth/reset-password';

  static const String logout = '$baseUrl/auth/logout';

  static const String currentUser = '$baseUrl/auth/me';

  static String updateUser(String userId) => '$baseUrl/auth/users/$userId';

  static String seatMap(String tripId) => '$baseUrl/trips/$tripId/seat-map';

  static String bookTrip(String tripId) => '$baseUrl/trips/$tripId/book';

  static const String createPaymentIntent = '$baseUrl/payments/create-intent';

  static String tripDetails(String tripId) => '$baseUrl/trips/$tripId';

  static String updateTrip(String tripId) => '$baseUrl/trips/$tripId';

  static String cancelTrip(String tripId) => '$baseUrl/trips/$tripId/cancel';



  static const String notifications = '$baseUrl/notifications';

  static String markNotificationRead(String id) =>
      '$baseUrl/notifications/$id/read';

  static const String markAllNotificationsRead =
      '$baseUrl/notifications/read-all';


  static const String socketUrl = 'https://api.rideshareproapp.com';

  static const String conversations = '$baseUrl/messages';

  static const String unreadMessagesCount = '$baseUrl/messages/unread';

  static String messageHistory(String bookingId) =>
      '$baseUrl/messages/$bookingId';

  static const String quickReplies = '$baseUrl/quick-replies';

    static String geocodeSearch(String query) =>
      '$baseUrl/geocode/search?q=${Uri.encodeQueryComponent(query)}';
}