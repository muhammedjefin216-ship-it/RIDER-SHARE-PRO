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
}
