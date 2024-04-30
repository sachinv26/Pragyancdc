class Appointment {
  String appointmentId;
  String branchName;
  String therapyName;
  String therapistName;
  String therapistImg;
  String parentName;
  String childName;
  String childImage;
  String amount;
  String appointmentDate;
  String appointmentTime;
  String transactionCreateDate;
  String appointmentStatus;
  String appointmentStatusNum;

  Appointment({
    required this.appointmentId,
    required this.branchName,
    required this.therapyName,
    required this.therapistName,
    required this.therapistImg,
    required this.parentName,
    required this.childName,
    required this.childImage,
    required this.amount,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.transactionCreateDate,
    required this.appointmentStatus,
    required this.appointmentStatusNum,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'],
      branchName: json['branch_name'],
      therapyName: json['therapy_name'],
      therapistName: json['therapist_name'],
      therapistImg: json['therapist_img'],
      parentName: json['parent_name'],
      childName: json['child_name'],
      childImage: json['child_image'],
      amount: json['amount'],
      appointmentDate: json['appointment_date'],
      appointmentTime: json['appointment_time'],
      transactionCreateDate: json['transaction_create_date'],
      appointmentStatus: json['appointment_status'],
      appointmentStatusNum: json['appointment_status_num'],
    );
  }
}