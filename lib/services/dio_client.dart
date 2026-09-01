import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../core/constants/api_constants.dart';

class DioClient {
  static Dio? _dio;
  static const _storage = FlutterSecureStorage();

  static Future<Dio> getInstance() async {
    if (_dio != null) return _dio!;

    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 15),
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

          if (isUnauthorized && !isRefreshCall) {
            try {
              final refreshResponse = await dio.post(ApiConstants.refreshToken);
              final newToken = refreshResponse.data['accessToken'] as String?;

              if (newToken != null) {
                await _storage.write(key: 'accessToken', value: newToken);

                final retryOptions = error.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $newToken';

                final retryResponse = await dio.fetch(retryOptions);
                return handler.resolve(retryResponse);
              }
            } catch (_) {}
          }

          handler.next(error);
        },
      ),
    );

    _dio = dio;
    return _dio!;
  }
}
