// Model class to hold temporary data
class TempModel {
  final String parentName;
  final String childName;
  final String childDOB;
  final String mailId;
  final String location;
  final String address;
  final String? imagePath;
  TempModel({
    required this.parentName,
    required this.childName,
    required this.childDOB,
    required this.mailId,
    required this.location,
    required this.address,
    this.imagePath,
  });
  @override
  String toString() {
    return 'TempModel(\n'
        '  parentName: $parentName,\n'
        '  childName: $childName,\n'
        '  childDOB: $childDOB,\n'
        '  mailId: $mailId,\n'
        '  location: $location,\n'
        '  address: $address\n'
        '  imagePath: $imagePath\n'
        ')';
  }
}
