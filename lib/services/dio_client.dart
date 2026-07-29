import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'api_constants.dart';

// ============================================================
// Single shared Dio instance for the whole app.
//
// Two things happen automatically on every request now:
//
// 1. AUTH HEADER — before each request goes out, we read the
//    stored accessToken from secure storage and attach it as
//    `Authorization: Bearer <token>`. Without this, protected
//    routes (e.g. GET /auth/me, /auth/logout) always fail with
//    401 regardless of anything else being correct.
//
// 2. AUTO-REFRESH ON 401 — access tokens expire after 15
//    minutes (see tokenGenerator.js). If a request comes back
//    401, we try refreshing the access token once (using the
//    refreshToken cookie), then silently retry the original
//    request with the new token. If refresh also fails, the 401
//    is passed through as normal — that's when the app should
//    send the user back to LoginScreen.
//
// Cookie handling (for the refresh-token cookie itself) still
// works the same as before: disk-based jar on mobile/desktop,
// browser-native credentials on web.
// ============================================================

class DioClient {
  static Dio? _dio;
  static const _storage = FlutterSecureStorage();

  static Future<Dio> getInstance() async {
    if (_dio != null) return _dio!;

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        extra: {'withCredentials': true},
      ),
    );

    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookieJar = PersistCookieJar(
        storage: FileStorage('${appDocDir.path}/.cookies/'),
      );
      dio.interceptors.add(CookieManager(cookieJar));
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'accessToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final isRefreshCall =
              error.requestOptions.path == ApiConstants.refreshToken;

          // Don't try to refresh if the failing call *was* the
          // refresh call itself — that would loop forever.
          if (isUnauthorized && !isRefreshCall) {
            try {
              final refreshResponse = await dio.post(ApiConstants.refreshToken);
              final newToken = refreshResponse.data['accessToken'] as String?;

              if (newToken != null) {
                await _storage.write(key: 'accessToken', value: newToken);

                // Retry the original request with the new token.
                final retryOptions = error.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $newToken';

                final retryResponse = await dio.fetch(retryOptions);
                return handler.resolve(retryResponse);
              }
            } catch (_) {
              // Refresh failed too — fall through and pass the
              // original 401 back to the caller. The app should
              // treat this as "session expired, go to login".
            }
          }

          handler.next(error);
        },
      ),
    );

    _dio = dio;
    return _dio!;
  }
}