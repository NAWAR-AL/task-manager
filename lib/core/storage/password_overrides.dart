import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// سجل تغيّرات كلمة المرور اللوكية، مفهرس بالإيميل:
///   email → {'local': <آخر كلمة كتبها المستخدم>, 'server': <الكلمة اللي بيقبلها السيرفر>}
///
/// السبب: السيرفر ما إلو endpoint تغيير كلمة مرور، فالتغيير بيبقى لوكل —
/// ولما المستخدم يدخل بالكلمة الجديدة، التطبيق بيبعت للسيرفر الكلمة الأصلية
/// المحفوظة بالخلفية ويقبّل الدخول بالجديدة.
class PasswordOverrides {
  static const String key = 'password_overrides';

  static Map<String, Map<String, String>> read(SharedPreferences prefs) {
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      return decoded.map(
        (k, v) => MapEntry(
          k.toString(),
          v is Map ? Map<String, String>.from(v) : <String, String>{},
        ),
      );
    } catch (_) {
      return {};
    }
  }

  static Future<void> write(
    SharedPreferences prefs,
    Map<String, Map<String, String>> map,
  ) async {
    await prefs.setString(key, jsonEncode(map));
  }
}
