// import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
import 'package:task_manager/core/constants/api_constants.dart';
import '../network/api_client.dart';
import 'injection_container.dart';

// Future<void> initCore() async {
//   // Dio
//   final dio = Dio();
//   sl.registerLazySingleton<Dio>(
//     () => Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl,
//         connectTimeout: Duration(seconds: 10),
//         receiveTimeout: Duration(seconds: 10),
//       ),
//     ),
//   );
//   // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
//   (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
//     final client = HttpClient();
//     client.badCertificateCallback =
//         (X509Certificate cert, String host, int port) => true;
//     return client;
//   };

//   dio.interceptors.add(
//     LogInterceptor(requestBody: true, responseBody: true, error: true),
//   );
//   // ApiClient
//   sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
// }

Future<void> initCore() async {
  // 1. إنشاء كائن Dio واحد وضبط خياراته وشهادات الأمان عليه مباشرة
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // 2. تفعيل تجاوز شهادات الأمان (Self-signed) على نفس الكائن
  // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
  //   final client = HttpClient();
  //   client.badCertificateCallback =
  //       (X509Certificate cert, String host, int port) => true;
  //   return client;
  // };

  // 3. إضافة الـ LogInterceptor لمراقبة الطلبات
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true, error: true),
  );

  // 4. تسجيل كائن الـ Dio الجاهز في الـ GetIt مرة واحدة فقط
  sl.registerLazySingleton<Dio>(() => dio);

  // 5. تسجيل الـ ApiClient
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
}
