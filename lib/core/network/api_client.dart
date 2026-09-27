import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager/main.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = 'https://taskback.orbit-eng.net/api';

    // إضافة Interceptor لإرفاق التوكن تلقائياً مع كل طلب
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          final token = prefs.getString(
            'auth_token',
          ); // استخدام نفس المفتاح تماماً

          // final token = prefs.getString(
          //   'auth_token',
          // ); // استخدام نفس المفتاح تماماً

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';

          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          }
          return handler.next(error);
        },
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}
