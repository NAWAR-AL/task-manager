import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/constants/api_constants.dart';
import 'package:task_manager/core/features/auth/presentation/pages/login_page.dart';

import '../network/api_client.dart';
import '../network/app_navigator.dart';
import 'injection_container.dart';

Future<void> initCore() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // SSL
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    return client;
  };

  // Authentication interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();

        final token = prefs.getString('auth_token');

        print('==============================');
        print(
          'TOKEN EXISTS: ${token != null && token.isNotEmpty}',
        );
        print(
          'TOKEN LENGTH: ${token?.length ?? 0}',
        );

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        options.headers['Accept'] = 'application/json';

        print(
          'AUTH HEADER EXISTS: '
          '${options.headers.containsKey('Authorization')}',
        );

        print('REQUEST URL: ${options.uri}');
        print('==============================');

        return handler.next(options);
      },
    ),
  );

  // Dio logs
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  );

  // Retry transient network failures (DNS lookup / connection setup).
  // Only failures that happen BEFORE the request reaches the server are
  // retried; HTTP errors and response timeouts are NOT retried so that
  // create/update requests are never sent twice.
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException err, ErrorInterceptorHandler handler) async {
        final isConnectionFailure =
            err.type == DioExceptionType.connectionTimeout ||
                err.type == DioExceptionType.connectionError;

        var attempts = (err.requestOptions.extra['_retryCount'] as int?) ?? 0;

        if (isConnectionFailure && attempts < 2) {
          err.requestOptions.extra['_retryCount'] = attempts + 1;
          await Future<void>.delayed(
            Duration(milliseconds: 500 * (attempts + 1)),
          );
          try {
            final response = await dio.fetch(err.requestOptions);
            return handler.resolve(response);
          } on DioException {
            // Retry attempt failed, fall through to the regular error handler.
          }
        }
        handler.next(err);
      },
    ),
  );

  // Auth guard: when the server rejects the stored token (HTTP 401), clear it
  // and send the user back to the login screen instead of showing a raw error.
  // Requests to the auth endpoints themselves (login/register/logout) are
  // excluded so the login page is not replaced while the user is entering
  // credentials.
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException err, ErrorInterceptorHandler handler) async {
        final path = err.requestOptions.path;

        final isAuthPath = path.contains('/login') ||
            path.contains('/register') ||
            path.contains('/logout');

        if (err.response?.statusCode == 401 && !isAuthPath) {
          final navigator = appNavigatorKey.currentState;
          // Capture before any await to avoid using a BuildContext across
          // an async gap.
          final messenger = navigator == null
              ? null
              : ScaffoldMessenger.maybeOf(navigator.context);

          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_token');

          navigator?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
          messenger?.showSnackBar(
            const SnackBar(
              content: Text('انتهت الجلسة، سجّل الدخول مرة أخرى'),
              backgroundColor: Colors.deepOrange,
            ),
          );
        }
        handler.next(err);
      },
    ),
  );

  // Register Dio
  sl.registerLazySingleton<Dio>(() => dio);

  // Register ApiClient
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl()),
  );
}