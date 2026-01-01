import 'package:expense_tracker/features/dashboard/domain/repository/user_details_repository.dart';

class FetchUserDetailsUsecase {
  final UserDetailsRepository repository;

  FetchUserDetailsUsecase(this.repository);

  Future<Map<String, dynamic>> call(String uid) {
    return repository.fetchUserDetails(uid);
  }
}
