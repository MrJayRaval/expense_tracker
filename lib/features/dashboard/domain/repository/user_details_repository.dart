abstract class UserDetailsRepository {
  Future<Map<String,dynamic>> fetchUserDetails(String uid);
}
