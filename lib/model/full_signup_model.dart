class FullSignUpModel {
  final String parentName;
  final String childName;
  final DateTime childDOB;
  final String email;
  final String location;
  final String address;
  final String password;
  final String phoneNumber;
  final String gender;

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
    required this.gender,

    //this.imagePath, // Pass the image path in the constructor
  });

  // Factory method to create a FullSignUpModel from a JSON map
  factory FullSignUpModel.fromJson(Map<String, dynamic> json) {
    return FullSignUpModel(
      parentName: json['prag_parent_name'] as String,
      childName: json['prag_child_name'] as String,
      // Parse the string into a DateTime
      childDOB: DateTime.parse(json['prag_child_dob']),
      email: json['prag_parent_email'] as String,
      location: json['prag_preferred_location'],
      address: json['prag_parent_address'] as String,
      phoneNumber: json['prag_parent_mobile'] as String,
      password: json['prag_parent_password'] as String,
      gender: json['prag_child_gender'] as String,
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
      'prag_parent_name': parentName,
      'prag_child_name': childName,
      'prag_child_dob': childDOB.toString().split(' ')[0],
      'prag_parent_email': email,
      'prag_preferred_location': location,
      'prag_parent_address': address,
      'prag_parent_password': password,
      'prag_parent_mobile': phoneNumber,
      'prag_child_gender': gender,
      "prag_parent_device_imei": "sdf45sdf5",
      "prag_parent_device_info": "samsung",
      //    'ImagePath': imagePath, // Include the image path in the JSON
    };
  }
}
