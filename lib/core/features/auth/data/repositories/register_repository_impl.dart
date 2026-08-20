import '../../domain/entities/register.dart';
import '../../domain/repositories/register_repository.dart';
import '../models/register_model.dart';
import '../datasources/register_remote_data_source.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDatasource remote;

  RegisterRepositoryImpl(this.remote);

  @override
  Future<void> register(Register register) async {
    final model = RegisterModel(
      username: register.username,
      email: register.email,
      password: register.password,
    );
    await remote.register(model);
  }
}