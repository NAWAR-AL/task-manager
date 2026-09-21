import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/constants/api_constants.dart';

import '../network/api_client.dart';
import 'injection_container.dart';

Future<void> initCore() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
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

  // Register Dio
  sl.registerLazySingleton<Dio>(() => dio);

  // Register ApiClient
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl()),
  );
}