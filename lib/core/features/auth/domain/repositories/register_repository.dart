import 'package:task_manager/core/features/auth/domain/entities/register.dart';

abstract class RegisterRepository {
  Future<void> register(Register register);
}
