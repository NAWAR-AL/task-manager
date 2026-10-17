import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';

/// الثيم الموحّد للتطبيق — كل الحقول والأزرار والبطاقات بتاخد ستايلها من هون
class AppTheme {
  AppTheme._();

  static const double radius = 16;
  static const double radiusSmall = 12;

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ColorsApp.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: ColorsApp.primary,
      surface: ColorsApp.surface,
      error: ColorsApp.danger,
    );

    final baseTextTheme = Typography.material2021().black.apply(
      bodyColor: ColorsApp.textPrimary,
      displayColor: ColorsApp.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ColorsApp.background,
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: ColorsApp.textPrimary,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: ColorsApp.textPrimary,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: ColorsApp.textPrimary,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: ColorsApp.textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorsApp.surface,
        foregroundColor: ColorsApp.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ColorsApp.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: ColorsApp.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: ColorsApp.divider),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorsApp.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: ColorsApp.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: ColorsApp.textSecondary, fontSize: 14),
        floatingLabelStyle: const TextStyle(
          color: ColorsApp.primary,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: ColorsApp.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: ColorsApp.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: ColorsApp.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: ColorsApp.danger, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsApp.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: ColorsApp.divider,
          disabledForegroundColor: ColorsApp.textMuted,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorsApp.primary,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: ColorsApp.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorsApp.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorsApp.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColorsApp.textPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ColorsApp.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: ColorsApp.textPrimary,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: ColorsApp.primary,
        unselectedLabelColor: ColorsApp.textSecondary,
        indicatorColor: ColorsApp.primary,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        dividerColor: ColorsApp.divider,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return ColorsApp.primary;
          return Colors.white;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: ColorsApp.textMuted),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorsApp.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: ColorsApp.primary,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: ColorsApp.textPrimary,
        ),
        subtitleTextStyle: TextStyle(fontSize: 13, color: ColorsApp.textSecondary),
      ),
    );
  }
}