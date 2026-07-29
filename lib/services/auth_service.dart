import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'dio_client.dart';

class AuthService {
  Future<Dio> get _dio async => await DioClient.getInstance();

  // ============================================================
  // REGISTER
  // ============================================================

  Future<Response> register({
    required String name,
    required String phone,
    required String email,
    required String gender,
    required String password,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'gender': gender.toLowerCase(),
          'password': password,
        },
      );

      return response;
    } on DioException catch (e) {
      print('REGISTER ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // VERIFY EMAIL
  // ============================================================

  Future<Response> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.verifyEmail,
        data: {
          'email': email,
          'otp': otp,
        },
      );

      return response;
    } on DioException catch (e) {
      print('VERIFY OTP ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<Response> resendOtp({
    required String email,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.resendOtp,
        data: {
          'email': email,
        },
      );

      return response;
    } on DioException catch (e) {
      print('RESEND OTP ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return response;
    } on DioException catch (e) {
      print('LOGIN ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // GOOGLE AUTH
  // ============================================================

  Future<Response> googleAuth({required String idToken}) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.google,
        data: {'idToken': idToken},
      );

      return response;
    } on DioException catch (e) {
      print('GOOGLE AUTH ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // REFRESH TOKEN
  // ============================================================

  Future<Response> refreshToken() async {
    try {
      final dio = await _dio;

      final response = await dio.post(ApiConstants.refreshToken);

      return response;
    } on DioException catch (e) {
      print('REFRESH TOKEN ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // GET CURRENT USER
  // ============================================================

  Future<Response> getCurrentUser() async {
    try {
      final dio = await _dio;

      final response = await dio.get(ApiConstants.currentUser);

      return response;
    } on DioException catch (e) {
      print('GET CURRENT USER ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // FORGOT PASSWORD — send OTP
  // ============================================================

  Future<Response> forgotPassword({required String email}) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      return response;
    } on DioException catch (e) {
      print('FORGOT PASSWORD ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // FORGOT PASSWORD — verify OTP
  // ============================================================

  Future<Response> verifyForgotOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.verifyForgotOtp,
        data: {'email': email, 'otp': otp},
      );

      return response;
    } on DioException catch (e) {
      print('VERIFY FORGOT OTP ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }

  // ============================================================
  // FORGOT PASSWORD — reset
  // ============================================================

  Future<Response> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final dio = await _dio;

      final response = await dio.post(
        ApiConstants.resetPassword,
        data: {'email': email, 'newPassword': newPassword},
      );

      return response;
    } on DioException catch (e) {
      print('RESET PASSWORD ERROR');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      rethrow;
    }
  }
}