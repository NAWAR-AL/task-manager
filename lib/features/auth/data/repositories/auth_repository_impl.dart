import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/models/login_model.dart';
import 'package:task_manager/features/auth/data/models/register_model.dart';
import 'package:task_manager/features/auth/data/models/reset_password_model.dart';
import 'package:task_manager/features/auth/domain/entities/login.dart';
import 'package:task_manager/features/auth/domain/entities/logout.dart';
import 'package:task_manager/features/auth/domain/entities/register.dart';
import 'package:task_manager/features/auth/domain/entities/reset_password.dart';
import 'package:task_manager/features/auth/domain/entities/user.dart';

import '../../domain/repositories/auth_repository.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remote;

  ForgotPasswordRepositoryImpl(this.remote);

  @override
  Future<void> forgot(String email) async {
    await remote.forgotPassword(email);
  }

  @override
  Future<void> reset(ResetPassword params) async {
    final model = ResetPasswordModel(
      token: params.token,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
    await remote.resetPassword(model);
  }
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDatasource remote;

  LoginRepositoryImpl(this.remote);

  @override
  Future<String> login(Login login) async {
    final model = LoginModel(email: login.email, password: login.password);
    return await remote.login(model);
  }

  @override
  Future<String> getMyRole() {
    return remote.getMyRole();
  }

  @override
  Future<bool> verifyPassword(String email, String password) {
    return remote.verifyPassword(email, password);
  }
}

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource remoteDataSource;

  LogoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<Logout> logout() async {
    try {
      final result = await remoteDataSource.logout();

      // مسح التوكن محلياً بعد نجاح الخروج من السيرفر
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      return Logout(success: result);
    } catch (e) {
      // في حال حدوث خطأ أو 401، نحذف التوكن محلياً أيضاً لنسمح للمستخدم بالخروج
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      return Logout(success: true);
    }
  }
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<User> getProfile() async {
    return await remote.getProfile();
  }

  @override
  Future<User> getUser(int id) async {
    return await remote.getUser(id);
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      final result = await remote.getUsers();

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<User>> getDashboardUsers() async {
    return await remote.getDashboardUsers();
  }

  @override
  Future<void> createUser(Register register) async {
    final model = RegisterModel(
      name: register.name,
      email: register.email,
      password: register.password,
      password_confirmation: register.password_confirmation,
    );
    await remote.createUser(model);
  }

  @override
  Future<void> updateUserRole(int userId, String role) async {
    await remote.updateUserRole(userId, role);
  }

  @override
  Future<void> deleteUSer(int userId) async {
    await remote.deleteUSer(userId);
  }

  @override
  Future<void> updateUSer(
    User userEntity,
    String? password,
    String? passwordConfirm,
  ) async {
    await remote.updateUserProfile(
      userId: userEntity.id,
      name: userEntity.name,
      email: userEntity.email,
      password: password,
      passwordConfirmation: passwordConfirm,
    );
  }
}

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDatasource remote;

  RegisterRepositoryImpl(this.remote);

  @override
  Future<void> register(Register register) async {
    final model = RegisterModel(
      name: register.name,
      email: register.email,
      password: register.password,
      password_confirmation: register.password_confirmation,
    );
    await remote.register(model);
  }
}
