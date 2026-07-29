import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_state.dart';
import '../services/auth_service.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  @override
  AuthState build() {
    return const AuthState();
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String gender,
    required String password,
  }) async {
    state = state.copyWith(isRegistering: true, clearError: true);

    try {
      final response = await _authService.register(
        name: name,
        phone: phone,
        email: email,
        gender: gender,
        password: password,
      );

      print('REGISTER RESPONSE: ${response.data}');

      state = state.copyWith(isRegistering: false, clearError: true);
      return true;
    } on DioException catch (e) {
      print('REGISTER DIO ERROR: ${e.message}');
      print('REGISTER STATUS CODE: ${e.response?.statusCode}');
      print('REGISTER RESPONSE DATA: ${e.response?.data}');

      String message = 'Registration failed';

      if (e.response?.data is Map) {
        final data = e.response!.data;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      final alreadyExists = e.response?.statusCode == 400 &&
          message.toLowerCase().contains('already exists');

      state = state.copyWith(
        isRegistering: false,
        errorMessage: alreadyExists ? null : message,
      );

      if (alreadyExists) return true;
      return false;
    } catch (e) {
      print('REGISTER UNKNOWN ERROR: $e');
      state = state.copyWith(isRegistering: false, errorMessage: e.toString());
      return false;
    }
  }

  // ============================================================
  // VERIFY EMAIL OTP
  // ============================================================

  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(isVerifying: true, clearError: true);

    try {
      final response = await _authService.verifyEmail(email: email, otp: otp);

      print('VERIFY OTP RESPONSE: ${response.data}');

      state = state.copyWith(isVerifying: false, clearError: true);
      return true;
    } on DioException catch (e) {
      print('VERIFY OTP DIO ERROR: ${e.message}');
      print('VERIFY OTP STATUS CODE: ${e.response?.statusCode}');
      print('VERIFY OTP RESPONSE DATA: ${e.response?.data}');

      String message = 'Unable to verify OTP';

      if (e.response?.data is Map) {
        final data = e.response!.data;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      state = state.copyWith(isVerifying: false, errorMessage: message);
      return false;
    } catch (e) {
      print('VERIFY OTP UNKNOWN ERROR: $e');
      state = state.copyWith(isVerifying: false, errorMessage: e.toString());
      return false;
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<bool> resendOtp({required String email}) async {
    state = state.copyWith(isResending: true, clearError: true);

    try {
      final response = await _authService.resendOtp(email: email);

      print('RESEND OTP RESPONSE: ${response.data}');

      state = state.copyWith(isResending: false, clearError: true);
      return true;
    } on DioException catch (e) {
      print('RESEND OTP DIO ERROR: ${e.message}');
      print('RESEND OTP STATUS CODE: ${e.response?.statusCode}');
      print('RESEND OTP RESPONSE DATA: ${e.response?.data}');

      String message = 'Unable to resend OTP';

      if (e.response?.data is Map) {
        final data = e.response!.data;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      state = state.copyWith(isResending: false, errorMessage: message);
      return false;
    } catch (e) {
      print('RESEND OTP UNKNOWN ERROR: $e');
      state = state.copyWith(isResending: false, errorMessage: e.toString());
      return false;
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoggingIn: true, clearError: true);

    try {
      final response = await _authService.login(email: email, password: password);

      final data = response.data;
      final token = data['accessToken'] as String?;

      if (token != null) {
        await _storage.write(key: 'accessToken', value: token);
      }
      await _storage.write(key: 'rememberMe', value: rememberMe.toString());

      state = state.copyWith(isLoggingIn: false, clearError: true);
      return {'success': true};
    } on DioException catch (e) {
      print('LOGIN DIO ERROR: ${e.message}');
      print('LOGIN STATUS CODE: ${e.response?.statusCode}');
      print('LOGIN RESPONSE DATA: ${e.response?.data}');

      String message = 'Login failed';
      bool requiresVerification = false;
      String? emailFromServer;

      if (e.response?.data is Map) {
        final data = e.response!.data;
        if (data['message'] != null) message = data['message'].toString();
        requiresVerification = data['requiresVerification'] == true;
        emailFromServer = data['email']?.toString();
      }

      state = state.copyWith(isLoggingIn: false, errorMessage: message);

      return {
        'success': false,
        'requiresVerification': requiresVerification,
        'email': emailFromServer,
        'message': message,
      };
    } catch (e) {
      state = state.copyWith(isLoggingIn: false, errorMessage: e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================================
  // GOOGLE AUTH
  // ============================================================

  Future<Map<String, dynamic>> googleAuth({required String idToken}) async {
    state = state.copyWith(isGoogleSigningIn: true, clearError: true);

    try {
      final response = await _authService.googleAuth(idToken: idToken);
      final data = response.data;
      final token = data['accessToken'] as String?;

      if (token != null) {
        await _storage.write(key: 'accessToken', value: token);
      }
      // Google sign-in always behaves like "remember me" since there's
      // no explicit checkbox for it in that flow.
      await _storage.write(key: 'rememberMe', value: 'true');

      state = state.copyWith(isGoogleSigningIn: false, clearError: true);
      return {'success': true, 'isNewUser': data['isNewUser'] == true};
    } on DioException catch (e) {
      String message = 'Google sign-in failed';
      if (e.response?.data is Map) {
        final data = e.response!.data;
        if (data['message'] != null) message = data['message'].toString();
      }
      state = state.copyWith(isGoogleSigningIn: false, errorMessage: message);
      return {'success': false, 'message': message};
    } catch (e) {
      state = state.copyWith(isGoogleSigningIn: false, errorMessage: e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================================
  // REFRESH TOKEN
  // ============================================================

  Future<bool> refreshAccessToken() async {
    try {
      final response = await _authService.refreshToken();
      final token = response.data['accessToken'] as String?;

      if (token != null) {
        await _storage.write(key: 'accessToken', value: token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('REFRESH ERROR: ${e.response?.data}');
      return false;
    } catch (e) {
      print('REFRESH UNKNOWN ERROR: $e');
      return false;
    }
  }

  // ============================================================
  // SESSION CHECK (used at app launch)
  //
  // Only attempts auto-login if the user previously checked
  // "Remember me" (or signed in with Google, which always sets
  // this flag). Otherwise, always sends the user to LoginScreen.
  // ============================================================

  Future<bool> checkSession() async {
    state = state.copyWith(isCheckingSession: true);

    try {
      final remember = await _storage.read(key: 'rememberMe');

      if (remember != 'true') {
        state = state.copyWith(isCheckingSession: false);
        return false;
      }

      final success = await refreshAccessToken();
      state = state.copyWith(isCheckingSession: false);
      return success;
    } catch (e) {
      print('SESSION CHECK ERROR: $e');
      state = state.copyWith(isCheckingSession: false);
      return false;
    }
  }

  // ============================================================
  // LOGOUT (local — clears stored session data)
  // ============================================================

  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
    await _storage.write(key: 'rememberMe', value: 'false');
  }

  // ============================================================
  // GET CURRENT USER
  // ============================================================

  Future<bool> fetchCurrentUser() async {
    state = state.copyWith(isLoadingUser: true);

    try {
      final response = await _authService.getCurrentUser();
      final user = response.data['user'];

      if (user != null) {
        state = state.copyWith(
          isLoadingUser: false,
          userId: user['id']?.toString() ?? user['_id']?.toString(),
          userName: user['name']?.toString(),
          userEmail: user['email']?.toString(),
          userPhoto: user['profilePhoto']?.toString(),
        );
        return true;
      }

      state = state.copyWith(isLoadingUser: false);
      return false;
    } on DioException catch (e) {
      print('FETCH CURRENT USER ERROR: ${e.response?.data}');
      state = state.copyWith(isLoadingUser: false);
      return false;
    } catch (e) {
      print('FETCH CURRENT USER UNKNOWN ERROR: $e');
      state = state.copyWith(isLoadingUser: false);
      return false;
    }
  }

  // ============================================================
  // FORGOT PASSWORD — send OTP
  // ============================================================

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    state = state.copyWith(isSendingForgotOtp: true, clearError: true);

    try {
      final response = await _authService.forgotPassword(email: email);

      state = state.copyWith(isSendingForgotOtp: false, clearError: true);
      return {
        'success': true,
        'message': response.data['message'] ?? 'OTP sent',
      };
    } on DioException catch (e) {
      String message = 'Unable to send OTP';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      state = state.copyWith(isSendingForgotOtp: false, errorMessage: message);
      return {'success': false, 'message': message};
    } catch (e) {
      state = state.copyWith(isSendingForgotOtp: false, errorMessage: e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================================
  // FORGOT PASSWORD — verify OTP
  // ============================================================

  Future<Map<String, dynamic>> verifyForgotOtp({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(isVerifyingForgotOtp: true, clearError: true);

    try {
      final response = await _authService.verifyForgotOtp(email: email, otp: otp);

      state = state.copyWith(
        isVerifyingForgotOtp: false,
        forgotOtpVerified: true,
        clearError: true,
      );
      return {
        'success': true,
        'message': response.data['message'] ?? 'OTP verified',
      };
    } on DioException catch (e) {
      String message = 'Invalid or expired OTP';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      state = state.copyWith(isVerifyingForgotOtp: false, errorMessage: message);
      return {'success': false, 'message': message};
    } catch (e) {
      state = state.copyWith(isVerifyingForgotOtp: false, errorMessage: e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================================
  // FORGOT PASSWORD — reset
  // ============================================================

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    state = state.copyWith(isResettingPassword: true, clearError: true);

    try {
      final response = await _authService.resetPassword(
        email: email,
        newPassword: newPassword,
      );

      state = state.copyWith(
        isResettingPassword: false,
        forgotOtpVerified: false,
        clearError: true,
      );
      return {
        'success': true,
        'message': response.data['message'] ?? 'Password reset successfully',
      };
    } on DioException catch (e) {
      String message = 'Unable to reset password';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      state = state.copyWith(isResettingPassword: false, errorMessage: message);
      return {'success': false, 'message': message};
    } catch (e) {
      state = state.copyWith(isResettingPassword: false, errorMessage: e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }
}