import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/domain/usecases/login_usecases.dart';
import 'package:task_manager/core/network/api_error.dart';
import 'package:task_manager/core/storage/password_overrides.dart';

/// تغيير كلمة المرور لوكل
/// ما في endpoint تغيير باسورد عالسيرفر بعد، فبنخزّن كلمة المرور
/// من وقت إنشاء الحساب والدخول (بـ PasswordOverrides مفهرس بالإيميل)،
/// ووقت المستخدم بغّيرها بنقارن القديمة بالمحفوظة وبنحدّث القيمة.
/// إذا ما في نسخة محفوظة (جلسات قديمة قبل التحديث) بنتأكد من
/// القديمة على السيرفر مباشرة وبنشئ المحفوظ من جديد.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldController = TextEditingController();
  final newController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    oldController.dispose();
    newController.dispose();
    super.dispose();
  }

  void _showSnack(ScaffoldMessengerState messenger, String message, Color color) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
  }

  Future<void> _change() async {
    if (_submitting) return;

    final messenger = ScaffoldMessenger.of(context);
    final oldPassword = oldController.text;
    final newPassword = newController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      _showSnack(messenger, 'Please fill in both fields', Colors.red[400]!);
      return;
    }
    if (newPassword.length < 6) {
      _showSnack(
        messenger,
        'New password must be at least 6 characters',
        Colors.red[400]!,
      );
      return;
    }
    if (newPassword == oldPassword) {
      _showSnack(
        messenger,
        'New password must be different from the old one',
        Colors.red[400]!,
      );
      return;
    }

    setState(() => _submitting = true);

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email')?.trim();
    final overrides = PasswordOverrides.read(prefs);
    final entry = (email == null) ? null : overrides[email];

    String? failure;
    Map<String, String>? updated;

    if (email == null) {
      // ما عرفنا مين المستخدم الحالي — نجرب بعدين بعد تسجيل دخول جديد
      failure =
          'No saved password on this device — log out and log in again, then retry';
    } else if (entry != null) {
      // المقارنة مع القيمة المخزنة لوكل
      if (entry['local'] == oldPassword) {
        updated = {...entry, 'local': newPassword};
      } else {
        failure = 'Old password is incorrect';
      }
    } else {
      // ما في نسخة محفوظة (جلسة قديمة قبل التحديث):
      // بنتأكد من القديمة على السيرفر وبنشئ المحفوظ من جديد
      try {
        final verified = await sl<LoginUsecase>().verifyPassword(
          email,
          oldPassword,
        );
        if (verified) {
          updated = {'local': newPassword, 'server': oldPassword};
        } else {
          failure = 'Old password is incorrect';
        }
      } catch (e) {
        failure = readableApiError(e);
      }
    }

    if (updated != null) {
      overrides[email!] = updated;
      await PasswordOverrides.write(prefs, overrides);
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    if (failure != null) {
      _showSnack(messenger, failure, Colors.red[400]!);
      return;
    }
    Navigator.pop(context);
    _showSnack(messenger, 'Password changed successfully', Colors.green[400]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Reset Password')),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Gap(8),
            Container(
              width: 96,
              height: 96,
              decoration:  BoxDecoration(
                color: ColorsApp.primarySoft,
                shape: BoxShape.circle,
              ),
              child:  Icon(
                Icons.password_rounded,
                size: 46,
                color: ColorsApp.primary,
              ),
            ),
            Gap(16),
            Text(
              'Reset Password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             Gap(8),
             Text(
              'Enter your old password and the new one.\n'
              'The old password is checked against the copy saved on this device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: ColorsApp.textSecondary,
              ),
            ),
             Gap(24),

            AppCard(
              child: Column(
                children: [
                  AppTextField(
                    controller: oldController,
                    label: 'Old Password',
                    prefixIcon: Icons.password,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                  ),
                 Gap(16),
                  AppTextField(
                    controller: newController,
                    label: 'New Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),

              Gap(24),

            AppButton(
              label: 'Change Password',
              icon: Icons.check_circle_outline,
              loading: _submitting,
              onPressed: _change,
            ),
          ],
        ),
      ),
    );
  }
}
