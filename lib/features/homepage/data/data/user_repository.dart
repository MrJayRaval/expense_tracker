import '../datasources/user_remote_data_source.dart';
import '../../domain/repository/user_details_repository.dart';

class UserDetailsRepositoryImpl implements UserDetailsRepository {
  final UserRemoteDataSource remoteDataSource;

  UserDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> fetchUserDetails(String uid) {
    return remoteDataSource.fetchUserData();
  }
}
