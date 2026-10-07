import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';

/// كارت أبيض بحواف دائرية وظل خفيف — الأساس لكل بطاقات التطبيق
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.card);
    final shadows = [
      BoxShadow(
        color: ColorsApp.primaryDark.withValues(alpha: 0.05),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ];

    if (onTap == null) {
      return Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: ColorsApp.surface,
          borderRadius: radius,
          border: Border.all(color: ColorsApp.divider),
          boxShadow: shadows,
        ),
        child: child,
      );
    }

    // نسخة قابلة للضغط — الخلفية على الـ Material حتى يظهر تأثير اللمس
    return Material(
      color: ColorsApp.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: ColorsApp.divider),
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// عناوين الأقسام داخل الكروت
class AppSectionTitle extends StatelessWidget {
  final String text;
  final IconData? icon;

  const AppSectionTitle({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: ColorsApp.primary),
          Gap(8),
        ],
        Text(
          text,
          style:  TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: ColorsApp.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// حقل إدخال موحّد الشكل
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style:  TextStyle(fontSize: 15, color: ColorsApp.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
      ),
    );
  }
}

/// قائمة منسدلة موحّدة الشكل
class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      borderRadius: BorderRadius.circular(AppRadius.field),
      icon:  Icon(Icons.keyboard_arrow_down_rounded),
      style: TextStyle(fontSize: 15, color: ColorsApp.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

/// حقل اختيار تاريخ
class AppDateField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsApp.surface,
      borderRadius: BorderRadius.circular(AppRadius.field),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.field),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.field),
            border: Border.all(color: ColorsApp.divider),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: ColorsApp.primary,
              ),
              Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style:  TextStyle(
                        fontSize: 12,
                        color: ColorsApp.textSecondary,
                      ),
                    ),
                    Gap(2),
                    Text(
                      value ?? 'Select a date',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: value == null
                            ? ColorsApp.textMuted
                            : ColorsApp.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
             Icon(
                Icons.expand_more_rounded,
                color: ColorsApp.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زر أساسي بستايل التطبيق + مؤشر تحميل
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? ColorsApp.primary;
    final fg = foregroundColor ?? Colors.white;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  Gap(8),
                ],
                Text(label),
              ],
            ),
    );
  }
}

/// شارة صغيرة ملوّنة (حالة / أولوية / دور)
class AppChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const AppChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
             SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String? status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: ColorsApp.prettyStatus(status),
      color: ColorsApp.statusColor(status),
      icon: Icons.circle,
    );
  }
}

class PriorityChip extends StatelessWidget {
  final String? priority;

  const PriorityChip({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: ColorsApp.prettyPriority(priority),
      color: ColorsApp.priorityColor(priority),
      icon: Icons.flag_outlined,
    );
  }
}

class RoleChip extends StatelessWidget {
  final String? role;

  const RoleChip({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: ColorsApp.prettyRole(role),
      color: ColorsApp.roleColor(role),
      icon: Icons.shield_outlined,
    );
  }
}

/// صفّ تفاصيل (أيقونة + عنوان + قيمة)
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: ColorsApp.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: ColorsApp.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorsApp.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// حالة فاضية (لا توجد بيانات)
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: ColorsApp.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: ColorsApp.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ColorsApp.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: ColorsApp.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// شاشة تحميل موحّدة
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}

/// أفاتار بالحروف الأولى من الاسم
class InitialsAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const InitialsAvatar({
    super.key,
    required this.name,
    this.radius = 26,
    this.backgroundColor,
    this.foregroundColor,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? ColorsApp.primarySoft,
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: radius * 0.62,
          fontWeight: FontWeight.w700,
          color: foregroundColor ?? ColorsApp.primary,
        ),
      ),
    );
  }
}

/// أبعاد موحّدة للتطبيق
class AppRadius {
  AppRadius._();

  static const double card = 20;
  static const double field = 14;
  static const double chip = 20;
}