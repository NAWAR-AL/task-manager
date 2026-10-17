import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';

/// حقل إدخال موحّد الستايل (يُستخدم بالمهام)
class TaskField extends StatelessWidget {
  final TextEditingController fieldController;
  final String fieldLabel;
  final int maxLines;
  final String? hint;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const TaskField({
    super.key,
    required this.fieldController,
    required this.fieldLabel,
    this.maxLines = 1,
    this.hint,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: fieldController,
      label: fieldLabel,
      hint: hint,
      maxLines: maxLines,
      prefixIcon: prefixIcon,
      validator: validator,
    );
  }
}