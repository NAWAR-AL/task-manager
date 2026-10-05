import 'package:dio/dio.dart';

/// غلاف بسيط يوفر الوصول إلى الـ [Dio] المُهيّأ بالكامل في `core_injection`.
///
/// إرفاق التوكن ومعالجة 401 تتم في الـ interceptors بالمكان الوحيد
/// (`core_injection.dart`) — لتجنّب تكرار الـ interception والأخطاء الناتجة
/// عن مسارات معالجة مكررة.
class ApiClient {
  final Dio dio;

  ApiClient(this.dio);
}