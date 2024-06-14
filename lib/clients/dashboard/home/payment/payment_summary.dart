import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';


class PaymentSummary extends StatefulWidget {
  const PaymentSummary({super.key});

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Payment Summary'
      ),
    );
  }
}
