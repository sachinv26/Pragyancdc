import 'dart:convert';

class CancelAppointment {
  final String appointmentId;
  final String branchId;
  final String branchName;
  final String therapyId;
  final String therapyName;
  final String therapistId;
  final String therapistName;
  final String parentId;
  final String parentName;
  final String childId;
  final String childName;
  final String amount;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentCreateDate;  // Updated to match API response
  final String appointmentCancelledBy;  // Updated to match API response
  final String cancelStatus;
  final String cancelStatusNum;
  final String cancelDate;
  final String cancelTranId;

  CancelAppointment({
    required this.appointmentId,
    required this.branchId,
    required this.branchName,
    required this.therapyId,
    required this.therapyName,
    required this.therapistId,
    required this.therapistName,
    required this.parentId,
    required this.parentName,
    required this.childId,
    required this.childName,
    required this.amount,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentCreateDate,  // Updated to match API response
    required this.appointmentCancelledBy,  // Updated to match API response
    required this.cancelStatus,
    required this.cancelStatusNum,
    required this.cancelDate,
    required this.cancelTranId,
  });

  factory CancelAppointment.fromJson(Map<String, dynamic> json) {
    return CancelAppointment(
      appointmentId: json['appointment_id'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      therapyId: json['therapy_id'],
      therapyName: json['therapy_name'],
      therapistId: json['therapist_id'],
      therapistName: json['therapist_name'],
      parentId: json['parent_id'],
      parentName: json['parent_name'],
      childId: json['child_id'],
      childName: json['child_name'],
      amount: json['amount'],
      appointmentDate: json['appointment_date'],
      appointmentTime: json['appointment_time'],
      appointmentCreateDate: json['appointment_create_date'],  // Updated to match API response
      appointmentCancelledBy: json['appointment_cancelled_by'],  // Updated to match API response
      cancelStatus: json['cancel_status'],
      cancelStatusNum: json['cancel_status_num'],
      cancelDate: json['cancel_date'],
      cancelTranId: json['cancel_tran_id'],
    );
  }
}
