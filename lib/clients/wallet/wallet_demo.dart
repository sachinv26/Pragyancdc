import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/api/parent_api.dart';
import 'package:pragyan_cdc/clients/wallet/transaction.dart';
import 'package:pragyan_cdc/clients/wallet/transaction_detail.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import '../../model/wallet_model.dart'; // Import the detail screen

class WalletScreen extends StatefulWidget {
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<ParentWalletResponse> futureWalletData;

  @override
  void initState() {
    super.initState();
    futureWalletData = Parent().getWalletTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(showLeading: false, title: 'Wallet'),
      body: FutureBuilder<ParentWalletResponse>(
        future: futureWalletData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final walletData = snapshot.data!;
            final walletBalance = double.parse(walletData.parentWallet);
            final transactions = walletData.walletTransaction;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Wallet Amount',
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            '₹${walletBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFeatureIcon(Icons.transfer_within_a_station, 'All', 0, transactions, walletBalance),
                        _buildFeatureIcon(Icons.account_balance_wallet, 'Credit', 1, transactions, walletBalance),
                        _buildFeatureIcon(Icons.add_circle_outline, 'Debit', 2, transactions, walletBalance),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transactions',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionsScreen(
                                  status: 0,
                                  transactions: transactions,
                                  walletBalance: walletBalance,
                                ),
                              ),
                            );
                          },
                          child: Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  transactions.isEmpty
                      ? Center(child: Text('No transactions found'))
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: transactions.length > 5 ? 5 : transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        title: Text(transaction.transactionFor),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              transaction.typeOfTransaction == 'Credit'
                                  ? '+₹${transaction.transactionAmount}'
                                  : '-₹${transaction.transactionAmount}',
                              style: TextStyle(
                                color: transaction.typeOfTransaction == 'Credit'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(transaction.credate))}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
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
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 20);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label, int status, List<WalletTransaction> transactions, double walletBalance) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionsScreen(
              status: status,
              transactions: transactions,
              walletBalance: walletBalance,
            ),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24.0,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue, size: 28.0),
          ),
          SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
