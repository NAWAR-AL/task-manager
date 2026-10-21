import 'package:dio/dio.dart';

/// بيحوّل أي خطأ من الـ API لرسالة إنسانية مقروءة،
/// بدل ما نعرض نص الـ DioException الطويل (422 من لاراڤيل بيرجّع
/// `message` + خريطة `errors` بالحقول، وهاد اللي لازم يوصل للمستخدم).
String readableApiError(
  Object error, {
  String fallback = 'Something went wrong, please try again',
}) {
  if (error is DioException) {
    final data = error.response?.data;

    if (data is Map) {
      // أخطاء التحقق (أدق رسالة): {errors: {email: ["The email ... taken."]}}
      final errors = data['errors'];
      if (errors is Map) {
        final messages = <String>[];
        errors.forEach((_, value) {
          if (value is List) {
            messages.addAll(value.map((e) => e.toString()));
          } else if (value != null) {
            messages.add(value.toString());
          }
        });
        if (messages.isNotEmpty) return messages.join('\n');
      }

      // رسالة السيرفر المباشرة
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }

    if (data is String && data.isNotEmpty) return data;

    // مشاكل الاتصال
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.receiveTimeout:
        return 'Connection problem, please try again';
      default:
        return fallback;
    }
  }

  return error.toString();
}
