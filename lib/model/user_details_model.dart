class UserProfile {
  final String parentName;
  final String parentMobile;
  final String parentEmail;
  final String preferredLocation;
  final String parentAddress;
  final String parentUserId;
  final String profileName;
  final String parentWallet;
  final String profileImage;
  final String parentAlternateNumber;
  final String parentMotherName;

  UserProfile({
    required this.parentName,
    required this.parentMobile,
    required this.parentEmail,
    required this.preferredLocation,
    required this.parentAddress,
    required this.parentUserId,
    required this.profileName,
    required this.parentWallet,
    required this.profileImage,
    required this.parentAlternateNumber,
    required this.parentMotherName,
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
      parentWallet: json['parent_wallet'] ?? '',
      profileImage: json['profile_image'] ?? '',
      parentAlternateNumber: json['prag_parent_alternate_number'] ?? '',
      parentMotherName: json['prag_parent_mother_name'] ?? '',
    );
  }
}
