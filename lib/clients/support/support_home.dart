import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';



class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'My Appointment',
        showLeading: false,
      ),
      body: Padding(
        padding:  const EdgeInsets.all(10),
        child: Center(
          child: Text('Support Screen'),
        ),
      ),
    );
  }
}
