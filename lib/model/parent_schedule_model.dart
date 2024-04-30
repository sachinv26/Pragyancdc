class ParentSchedule {
  final String appointmentId;
  final String branchId;
  final String branchName;
  final String therapyId;
  final String therapyName;
  final String therapistId;
  final String therapistName;
  final String therapistImg;
  final String parentId;
  final String parentName;
  final String childId;
  final String childName;
  final String childImage;
  final String amount;
  final String appointmentDate;
  final String appointmentTime;
  final String transactionCreateDate;
  final String appointmentStatus;
  final String appointmentStatusNum;

  ParentSchedule({
    required this.appointmentId,
    required this.branchId,
    required this.branchName,
    required this.therapyId,
    required this.therapyName,
    required this.therapistId,
    required this.therapistName,
    required this.therapistImg,
    required this.parentId,
    required this.parentName,
    required this.childId,
    required this.childName,
    required this.childImage,
    required this.amount,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.transactionCreateDate,
    required this.appointmentStatus,
    required this.appointmentStatusNum,
  });

  factory ParentSchedule.fromJson(Map<String, dynamic> json) {
    return ParentSchedule(
      appointmentId: json['appointment_id'] ?? '',
      branchId: json['branch_id'] ?? '',
      branchName: json['branch_name'] ?? '',
      therapyId: json['therapy_id'] ?? '',
      therapyName: json['therapy_name'] ?? '',
      therapistId: json['therapist_id'] ?? '',
      therapistName: json['therapist_name'] ?? '',
      therapistImg: json['therapist_img'] ?? '',
      parentId: json['parent_id'] ?? '',
      parentName: json['parent_name'] ?? '',
      childId: json['child_id'] ?? '',
      childName: json['child_name'] ?? '',
      childImage: json['child_image'] ?? '',
      amount: json['amount'] ?? '',
      appointmentDate: json['appointment_date'] ?? '',
      appointmentTime: json['appointment_time'] ?? '',
      transactionCreateDate: json['transaction_create_date'] ?? '',
      appointmentStatus: json['appointment_status'] ?? '',
      appointmentStatusNum: json['appointment_status_num'] ?? '',
    );
  }
}
