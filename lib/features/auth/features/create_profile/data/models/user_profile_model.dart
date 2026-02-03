class UserProfileModel {
  final String uid;
  final String name;
  final String email;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email};
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'],
      name:map['name'],
      email:map['email']
    );
  }
}
