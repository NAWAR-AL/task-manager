import 'package:dio/dio.dart';
import 'package:task_manager/core/constants/api_constants.dart';
import '../network/api_client.dart';
import 'injection_container.dart';

Future<void> initCore() async {
  // Dio
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    ),
  );

  // ApiClient
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
}
