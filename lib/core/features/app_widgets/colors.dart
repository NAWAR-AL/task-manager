import 'package:flutter/material.dart';


class ColorsApp {
  ColorsApp._();

  //  الألوان الأساسية 
  static const Color primary = Color(0xff1976D2);
  static const Color primaryDark = Color(0xff12579E);
  static const Color primarySoft = Color(0xffEAF3FF);

  // الأسطح والنصوص 
  static const Color background = Color(0xffF4F7FB);
  static const Color surface = Colors.white;
  static const Color divider = Color(0xffE4E9F2);
  static const Color textPrimary = Color(0xff102A43);
  static const Color textSecondary = Color(0xff718096);
  static const Color textMuted = Color(0xffA0AEC0);

  //  ألوان دلالية 
  static const Color success = Color(0xff2E9E5B);
  static const Color warning = Color(0xffE8A33D);
  static const Color danger = Color(0xffE05252);
  static const Color info = Color(0xff3B82F6);
  static const Color purple = Color(0xff7E57C2);
  static const Color slate = Color(0xff64748B);

  //  ألوان قديمة (للاستخدام في الكروت المتناوبة) 
  static Color background1 = const Color(0xff9BCEC1);
  static Color background2 = const Color(0xffFFEBD3);
  static Color background3 = const Color(0xffFFB6A6);
  static Color icons = const Color(0xff67A2C5);

  static List<Color> projectColors = [background1, background2, background3];


  /// لون حالة التاسك/المشروع (todo, in_progress, review, done, active, on_hold, completed)
  static Color statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'todo':
        return info;
      case 'in_progress':
        return warning;
      case 'review':
        return purple;
      case 'done':
      case 'completed':
        return success;
      case 'active':
        return success;
      case 'on_hold':
        return slate;
      default:
        return slate;
    }
  }

  /// لون الأولوية (low, medium, high)
  static Color priorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return danger;
      case 'medium':
        return warning;
      case 'low':
        return success;
      default:
        return slate;
    }
  }

  /// لون دور المستخدم (admin, developer, editor)
  static Color roleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return danger;
      case 'developer':
        return info;
      case 'editor':
        return warning;
      default:
        return slate;
    }
  }

  /// تحويل "in_progress" إلى "In Progress"
  static String prettyStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'todo':
        return 'To Do';
      case 'in_progress':
        return 'In Progress';
      case 'review':
        return 'Review';
      case 'done':
        return 'Done';
      case 'active':
        return 'Active';
      case 'on_hold':
        return 'On Hold';
      case 'completed':
        return 'Completed';
      case null || '':
        return '—';
      default:
        return _capitalize(status ?? '');
    }
  }

  static String prettyPriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      case null || '':
        return '—';
      default:
        return _capitalize(priority ?? '');
    }
  }

  static String prettyRole(String? role) {
    if (role == null || role.isEmpty) return '—';
    return _capitalize(role);
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}