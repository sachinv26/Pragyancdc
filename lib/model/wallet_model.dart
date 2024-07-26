class ParentWalletResponse {
  final int status;
  final String message;
  final String totalTransaction;
  final String parentWallet;
  final List<WalletTransaction> walletTransaction;

  ParentWalletResponse({
    required this.status,
    required this.message,
    required this.totalTransaction,
    required this.parentWallet,
    required this.walletTransaction,
  });

  factory ParentWalletResponse.fromJson(Map<String, dynamic> json) {
    var list = json['wallet_transaction'] as List;
    List<WalletTransaction> transactionsList =
    list.map((i) => WalletTransaction.fromJson(i)).toList();

    return ParentWalletResponse(
      status: json['status'],
      message: json['message'],
      totalTransaction: json['total_transaction'],
      parentWallet: json['parent_wallet'],
      walletTransaction: transactionsList,
    );
  }
}

class WalletTransaction {
  final String walletTransactionId;
  final String appointmentId;
  final String bookingMainId;
  final String typeOfTransaction;
  final String transactionFor;
  final int transactionForNum;
  final String oldWalletAmount;
  final String transactionAmount;
  final String adminId;
  final String adminName;
  final String walletAmount;
  final String rewardNote;
  final String credate;

  WalletTransaction({
    required this.walletTransactionId,
    required this.appointmentId,
    required this.bookingMainId,
    required this.typeOfTransaction,
    required this.transactionFor,
    required this.transactionForNum,
    required this.oldWalletAmount,
    required this.transactionAmount,
    required this.adminId,
    required this.adminName,
    required this.walletAmount,
    required this.rewardNote,
    required this.credate,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      walletTransactionId: json['wallet_transaction_id'],
      appointmentId: json['appointment_id'],
      bookingMainId: json['booking_main_id'],
      typeOfTransaction: json['typeof_transaction'],
      transactionFor: json['transaction_for'],
      transactionForNum: json['transaction_fornum'],
      oldWalletAmount: json['old_wallet_amount'],
      transactionAmount: json['transaction_amount'],
      adminId: json['admin_id'],
      adminName: json['admin_name'],
      walletAmount: json['wallet_amount'],
      rewardNote: json['reward_note'],
      credate: json['credate'],
    );
  }
}
