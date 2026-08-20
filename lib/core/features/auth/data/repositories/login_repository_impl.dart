import '../../domain/entities/login.dart';
import '../../domain/repositories/login_repository.dart';
import '../models/login_model.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDatasource remote;

  LoginRepositoryImpl(this.remote);

  @override
  Future<String> login(Login login) async {
    final model = LoginModel(
      username: login.username,
      password: login.password,
    );
   return await remote.login(model);
  }
}
