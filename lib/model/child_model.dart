class ChildModel {
  final String childId;
  final String childName;
  final String childDob;
  final String childGender;
  final String childImage;
  final String relationship;

  ChildModel({
    required this.childId,
    required this.childName,
    required this.childDob,
    required this.childGender,
    required this.childImage,
    required this.relationship,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      childId: json['child_id'] ?? '',
      childName: json['child_name'] ?? '',
      childDob: json['child_dob'] ?? '',
      childGender: json['child_gender'] ?? '',
      childImage: json['child_image'] ?? '',
      relationship: json['relationship'] ?? '',
    );
  }
}
