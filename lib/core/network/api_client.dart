import 'package:dio/dio.dart';


class ApiClient {
  late final Dio dio;

  ApiClient(this.dio);
  // ApiClient() {
  //   dio = Dio(
  //     BaseOptions(
  //       baseUrl: ApiConstants.baseUrl,
  //       connectTimeout: Duration(seconds: 15),
  //       receiveTimeout: Duration(seconds: 15),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //     ),
  //   );
  //   dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  // }
}
