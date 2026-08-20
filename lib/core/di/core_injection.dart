import 'package:dio/dio.dart';
import '../network/api_client.dart';
import 'injection_container.dart';

Future<void> initCore() async {
  // Dio
  sl.registerLazySingleton<Dio>(
    () => Dio(),
  );

  // ApiClient
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );
}