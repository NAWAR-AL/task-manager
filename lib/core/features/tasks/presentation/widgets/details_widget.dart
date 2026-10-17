import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';

/// صف تفاصيل موحّد — يتوافق مع الاستخدام القديم (title بصيغة "Name: ")
Widget buildDetailRow({
  required IconData icon,
  required String title,
  required String value,
}) {
  final label = title.endsWith(':') ? title.substring(0, title.length - 1).trim() : title;
  final safeValue = value.trim().isEmpty ? '—' : value;
  return DetailRow(icon: icon, label: label, value: safeValue);
}