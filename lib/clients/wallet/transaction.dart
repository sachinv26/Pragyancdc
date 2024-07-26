import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/clients/wallet/transaction_detail.dart';
import '../../model/wallet_model.dart';
import 'package:pragyan_cdc/constants/appbar.dart'; // Import the detail screen

class TransactionsScreen extends StatelessWidget {
  final int status; // 0 - All, 1 - Credit, 2 - Debit
  final List<WalletTransaction> transactions;
  final double walletBalance;

  TransactionsScreen({
    required this.status,
    required this.transactions,
    required this.walletBalance,
  });

  @override
  Widget build(BuildContext context) {
    List<WalletTransaction> filteredTransactions = transactions.where((transaction) {
      if (status == 1) {
        return transaction.typeOfTransaction == 'Credit';
      } else if (status == 2) {
        return transaction.typeOfTransaction == 'Debit';
      } else {
        return true;
      }
    }).toList();

    return Scaffold(
      appBar: customAppBar(
        showLeading: true,
        title: 'Transactions',
      ),
      body: filteredTransactions.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('No transactions found'),
        ),
      )
          :SingleChildScrollView(
        child: Column(
          children: [
             ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        transaction.transactionFor,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy').format(DateTime.parse(transaction.credate)),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            transaction.typeOfTransaction == 'Credit'
                                ? '+₹${transaction.transactionAmount}'
                                : '-₹${transaction.transactionAmount}',
                            style: TextStyle(
                              color: transaction.typeOfTransaction == 'Credit' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Icon(
                            transaction.typeOfTransaction == 'Credit' ? Icons.arrow_downward : Icons.arrow_upward,
                            color: transaction.typeOfTransaction == 'Credit' ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailScreen(transaction: transaction),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
          ],
        ),
      ),
    );
  }
}
