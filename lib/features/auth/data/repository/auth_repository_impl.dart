import '../datasources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> signUp(String email, String password) {
    return remoteDataSource.signUp(email, password);
  }

  @override
  Future<void> signIn(String email, String password) {
    return remoteDataSource.signIn(email, password);
  }

  @override
  Future<void> resetPassword(String email) {
    return remoteDataSource.resetPassword(email);
  }
}
