import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';

class ClientDetails extends StatelessWidget {
  const ClientDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Client Details'),
    );
  }
}
