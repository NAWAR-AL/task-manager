import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = 'https://taskback.orbit-eng.net/api';
    
    // إضافة Interceptor لإرفاق التوكن تلقائياً مع كل طلب
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token'); // استخدام نفس المفتاح تماماً

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';

          return handler.next(options);
        },
      ),
    );
  }
}