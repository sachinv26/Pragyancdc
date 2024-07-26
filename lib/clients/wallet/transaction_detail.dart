import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/wallet_model.dart';
import 'package:pragyan_cdc/constants/appbar.dart';

class TransactionDetailScreen extends StatelessWidget {
  final WalletTransaction transaction;

  TransactionDetailScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        showLeading: true,
        title: 'Transaction Details',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white70,
                border: Border(
                  top: BorderSide(
                    color: Colors.green.shade700,
                    width: 4.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction For: ${transaction.transactionFor}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Transaction ID: ${transaction.walletTransactionId}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Booking Main ID: ${transaction.bookingMainId}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Appointment ID: ${transaction.appointmentId}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Amount: ${transaction.typeOfTransaction == 'Credit' ? '+' : '-'}${'₹' + transaction.transactionAmount}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: transaction.typeOfTransaction == 'Credit' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Old Wallet Amount: ₹${transaction.oldWalletAmount}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'New Wallet Amount: ₹${transaction.walletAmount}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(transaction.credate))}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16.0),
                    if (transaction.rewardNote.isNotEmpty)
                      Text(
                        'Reward Note: ${transaction.rewardNote}',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
