class FullSignUpModel {
  final String parentName;
  final String childName;
  final String childDOB;
  final String email;
  final String location;
  final String address;
  final String password;
  final String phoneNumber;

  FullSignUpModel({
    required this.parentName,
    required this.childName,
    required this.childDOB,
    required this.email,
    required this.location,
    required this.address,
    required this.password,
    required this.phoneNumber,
  });

  //to print the model class
  @override
  String toString() {
    return 'FullSignModel(\n'
        '  parentName: $parentName,\n'
        '  childName: $childName,\n'
        '  childDOB: $childDOB,\n'
        '  mailId: $email,\n'
        '  location: $location,\n'
        '  address: $address\n'
        '  phoneNumber: $phoneNumber\n'
        '  password: $password\n'
        ')';
  }
}
