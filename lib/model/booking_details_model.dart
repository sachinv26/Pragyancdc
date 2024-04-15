class BookingDetailsModel {
  final String pragParent;
  final int pragTransactionId;
  final int pragTransactionDiscount;
  final int pragTransactionAmount;
  final List<Map<String, dynamic>> pragBooking;

  BookingDetailsModel({
    required this.pragParent,
    required this.pragTransactionId,
    required this.pragTransactionDiscount,
    required this.pragTransactionAmount,
    required this.pragBooking,
  });

  Map<String, dynamic> toJson() {
    return {
      'prag_parent': pragParent,
      'prag_transactionid': pragTransactionId,
      'prag_transactiondiscount': pragTransactionDiscount,
      'prag_transactionamount': pragTransactionAmount,
      'prag_booking': pragBooking,
    };
  }
}
