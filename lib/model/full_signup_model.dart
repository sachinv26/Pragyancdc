class FullSignUpModel {
  final String parentName;
  final String childName;
  final DateTime childDOB;
  final String email;
  final String location;
  final String address;
  final String password;
  final String phoneNumber;
//  final String? imagePath; // New field for the image path

  FullSignUpModel({
    required this.parentName,
    required this.childName,
    required this.childDOB,
    required this.email,
    required this.location,
    required this.address,
    required this.password,
    required this.phoneNumber,
    //this.imagePath, // Pass the image path in the constructor
  });

  // Factory method to create a FullSignUpModel from a JSON map
  factory FullSignUpModel.fromJson(Map<String, dynamic> json) {
    return FullSignUpModel(
      parentName: json['ParentName'] as String,
      childName: json['ChildName'] as String,
      // Parse the string into a DateTime
      childDOB: DateTime.parse(json['DOB']),
      email: json['Email'] as String,
      location: json['Location'] as String,
      address: json['Address'] as String,
      phoneNumber: json['MobileNumber'] as String,
      password: json['Password'] as String,
      // imagePath: json['ImagePath'] as String, // Add the image path field
    );
  }

  // To print the model class
  @override
  String toString() {
    return 'FullSignModel(\n'
        '  parentName: $parentName,\n'
        '  childName: $childName,\n'
        '  childDOB: $childDOB,\n'
        '  mailId: $email,\n'
        '  location: $location,\n'
        '  address: $address,\n'
        '  phoneNumber: $phoneNumber,\n'
        '  password: $password,\n'
        //    '  imagePath: $imagePath\n' // Include the image path in the toString output
        ')';
  }

  Map<String, dynamic> toJson() {
    return {
      'ParentName': parentName,
      'ChildName': childName,
      'DOB': childDOB.toString().split(' ')[0],
      'Email': email,
      'Location': location,
      'Address': address,
      'Password': password,
      'MobileNumber': phoneNumber,
      //    'ImagePath': imagePath, // Include the image path in the JSON
    };
  }
}
