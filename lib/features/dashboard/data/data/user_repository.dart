import 'package:expense_tracker/features/dashboard/data/datasources/user_remote_data_source.dart';
import 'package:expense_tracker/features/dashboard/domain/repository/user_details_repository.dart';

class UserDetailsRepositoryImpl implements UserDetailsRepository {
  final UserRemoteDataSource remoteDataSource;

  UserDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> fetchUserDetails(String uid) {
    return remoteDataSource.fetchUserData();
  }
}
