import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/payment/payment_success.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';

import '../../../../api/therapy_api.dart';


class PaymentSummary extends StatefulWidget {
  final String branchName;
  final String childName;
  final Map<String, dynamic> bookingData;

  const PaymentSummary({
    Key? key,
    required this.branchName,
    required this.childName,
    required this.bookingData,
  }) : super(key: key);

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  Future<void> _bookAppointment() async {
    try {
      // Calculate total amount, discount, and net amount
      double totalCost = 0;
      int totalSessions = 0;
      DateTime? earliestDate;
      DateTime? latestDate;

      // Iterate over booking data to compute the required amounts and dates
      widget.bookingData["prag_booking"].forEach((booking) {
        booking["prag_bookingdatetime"].forEach((date, slots) {
          DateTime parsedDate = DateTime.parse(date);
          earliestDate ??= parsedDate;
          latestDate ??= parsedDate;
          if (parsedDate.isBefore(earliestDate!)) {
            earliestDate = parsedDate;
          }
          if (parsedDate.isAfter(latestDate!)) {
            latestDate = parsedDate;
          }

          // Calculate cost for each slot
          slots.forEach((slot) {
            double cost = double.parse(slot[1].toString());
            totalCost += cost;
            totalSessions++;
          });
        });
      });

      // Determine discount eligibility
      bool isDiscountEligible = totalSessions >= 24 &&
          earliestDate != null &&
          latestDate != null &&
          latestDate!.difference(earliestDate!).inDays <= 30;

      double discount = isDiscountEligible ? 200.0 * totalSessions : 0.0;
      double netAmount = totalCost - discount;

      // Prepare the transaction data for the first API call
      final transactionData = {
        'prag_parent': widget.bookingData['prag_parent'],
        'prag_child': widget.bookingData['prag_booking'][0]['prag_child'],
        'prag_tran_type': 4, // Cash on Pay
        'prag_total_amount': totalCost.toStringAsFixed(2),
        'prag_discount': discount.toStringAsFixed(2),
        'prag_net_amount': netAmount.toStringAsFixed(2),
        'prag_paymentgateway': 4,
        'prag_tran_description':''
        // Cash on Pay
      };

      // Get the transaction ID using the first API call
      final Map<String, dynamic> transactionResponse = await TherapistApi().getTransactionIdApi(transactionData);

      if (transactionResponse['status'] == 1) {
        final transactionId = transactionResponse['transaction_id'];

        // Prepare the final booking data for the book appointment API
        final bookingData = {
          'prag_parent': widget.bookingData['prag_parent'],
          'prag_transactionid': transactionId,
          'prag_transactiondiscount': discount.toStringAsFixed(2),
          'prag_transactionamount': netAmount.toStringAsFixed(2),
          'prag_booking': widget.bookingData['prag_booking'],
        };

        // Call the book appointment API
        final Map<String, dynamic> response =
        await TherapistApi().bookAppointmentApi(bookingData);

        if (response['status'] == 1) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SuccessfulPayment(),
            ),
          );
        } else if (response['status'] == -2) {
          List<Map<String, dynamic>> bookedDates =
          List<Map<String, dynamic>>.from(response['bookeddate']);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Booking Error'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(response['message']),
                    SizedBox(height: 10),
                    Text('Booked Dates:'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: bookedDates.map((date) {
                        return Text('- ${date['prag_bookeddate']}');
                      }).toList(),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Booking Error'),
                content: Text(response['message']),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Transaction Error'),
              content: Text(transactionResponse['message']),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to book appointment. Error: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = 0;
    int totalSessions = 0;
    DateTime? earliestDate;
    DateTime? latestDate;
    Map<double, int> costBreakdown = {};

    widget.bookingData["prag_booking"].forEach((booking) {
      booking["prag_bookingdatetime"].forEach((date, slots) {
        DateTime parsedDate = DateTime.parse(date);
        if (earliestDate == null || parsedDate.isBefore(earliestDate!)) {
          earliestDate = parsedDate;
        }
        if (latestDate == null || parsedDate.isAfter(latestDate!)) {
          latestDate = parsedDate;
        }
        slots.forEach((slot) {
          double cost = double.parse(slot[1].toString());
          totalCost += cost;
          totalSessions++;
          if (costBreakdown.containsKey(cost)) {
            costBreakdown[cost] = costBreakdown[cost]! + 1;
          } else {
            costBreakdown[cost] = 1;
          }
        });
      });
    });

    bool isDiscountEligible = totalSessions >= 24 &&
        earliestDate != null &&
        latestDate != null &&
        latestDate!.difference(earliestDate!).inDays <= 30;

    double discount = isDiscountEligible ? 200.0 * totalSessions : 0.0;
    double finalCost = totalCost - discount;

    return Scaffold(
      appBar: customAppBar(title: 'Payment Summary'),
      body: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(16.0),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branch: ${widget.branchName}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Child: ${widget.childName}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 30, thickness: 2),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'No. of Sessions',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Cost',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Total',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      ...costBreakdown.entries.map((entry) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${entry.value}',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '₹${entry.key.toStringAsFixed(0)} per session',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '₹${(entry.key * entry.value).toStringAsFixed(0)}',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  Divider(height: 30, thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${totalCost.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (isDiscountEligible) ...[
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Discount: ₹${discount.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 17, color: Colors.green),
                      ),
                    ),
                  ],
                  Divider(height: 30, thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Final Cost',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${finalCost.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      onPressed: _bookAppointment,
                      text: 'Pay Now',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

