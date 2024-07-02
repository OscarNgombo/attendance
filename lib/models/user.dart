class UserProfile {
  late String displayName;
  late String email;
  late String phoneNumber;
  String? photoURL;

  UserProfile({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
  });

  factory UserProfile.fromJson(dynamic json) {
    return UserProfile(
      displayName: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photoURL: json['photoURL'],
    );
  }
}

