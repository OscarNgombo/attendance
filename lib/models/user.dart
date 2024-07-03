class UserProfile {
  late String displayName;
  late String email;
  late String phoneNumber;
  late String userID;
  String? photoURL;

  UserProfile({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
    required this.userID,
  });

  factory UserProfile.fromJson(dynamic json) {
    return UserProfile(
      userID: json['userId'] ?? '',
      displayName: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photoURL: json['photoURL'],
    );
  }
  // Method to update the userId
  UserProfile withUserId(  String userID) {
    return UserProfile(
      userID: userID,
      displayName: displayName,
      email: email,
      phoneNumber: phoneNumber,
      photoURL: photoURL,
    );
  }
}

