class UserProfile {
  final String parentName;
  final String parentMobile;
  final String parentEmail;
  final String preferredLocation;
  final String parentAddress;
  final String parentUserId;
  final String profileName;
  final String profileImage;
  //final String parentAuthToken;

  UserProfile({
    required this.parentName,
    required this.parentMobile,
    required this.parentEmail,
    required this.preferredLocation,
    required this.parentAddress,
    required this.parentUserId,
    required this.profileName,
    required this.profileImage,
    // required this.parentAuthToken,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      parentName: json['prag_parent_name'] ?? '',
      parentMobile: json['prag_parent_mobile'] ?? '',
      parentEmail: json['prag_parent_email'] ?? '',
      preferredLocation: json['prag_preferred_location'] ?? '',
      parentAddress: json['prag_parent_address'] ?? '',
      parentUserId: json['parent_user_id'] ?? '',
      profileName: json['profile_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      // parentAuthToken: json['prag_parent_auth_token'] ?? '',
    );
  }
}
