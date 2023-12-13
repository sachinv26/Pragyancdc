class UserDetailsModel {
  final String userId;
  final String parentName;
  final String childName;
  final String password;
  final DateTime dob;
  final String? profileImage;
  final String mobileNumber;
  final String email;
  final String? location;
  final String? address;
  final DateTime createdAt;

  UserDetailsModel({
    required this.userId,
    required this.parentName,
    required this.childName,
    required this.password,
    required this.dob,
    this.profileImage,
    required this.mobileNumber,
    required this.email,
    this.location,
    this.address,
    required this.createdAt,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      userId: json['UserID'],
      parentName: json['ParentName'],
      childName: json['ChildName'],
      password: json['Password'],
      dob: DateTime.parse(json['DOB']),
      profileImage: json['ProfileImage'],
      mobileNumber: json['MobileNumber'],
      email: json['Email'],
      location: json['Location'],
      address: json['Address'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}
