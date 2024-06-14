import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/phone_verification/verify.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'dart:convert';

import 'package:pragyan_cdc/provider/phone_verification_provider.dart';
import 'package:provider/provider.dart';

class PhoneNumberVerification extends StatefulWidget {
  final String otpFor;
  BuildContext ctx;
  final String? userid;
  PhoneNumberVerification({required this.ctx, required this.otpFor, Key? key, this.userid})
      : super(key: key);
  static String verify = "";


  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _phoneErrorMessage;

  var phone = '';

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }
  void _showPhoneErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    var phoneVerificationProvider = Provider.of<PhoneVerificationProvider>(
      context,
    );
    return Scaffold(
      appBar: customAppBar(
        title: 'Phone Verification'
      ),
      body: SafeArea(

        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          padding: const EdgeInsets.all(10),
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kheight30,

                  const Text(
                    "We need to verify your phone before getting started!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/img1.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            inputFormatters: [LengthLimitingTextInputFormatter(10)],
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              phone = value;
                              _phoneErrorMessage = null; // Reset the error message
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone is required';
                              }
                              if (value.length != 10) {
                                return 'number should be exactly 10 digits';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                              errorText: null, // Remove the default error text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Call the SnackBar method when the error message changes
                  kheight30,
                  CustomButton(
                      onPressed: () async {
                        //final mobNumber = countryController.text + phone;
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> result = await ApiServices()
                              .generateOtp(
                                  mobile: phone,
                                  userId: '0',
                                  otpFor: widget.otpFor);
                          print('Result is $result');
                          final String rawCode = result['gen'];
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return VerifyNumber(
                                ctx: widget.ctx,
                                otpFor: widget.otpFor,
                                phone: phone,
                                originalCode: rawCode,
                              );
                            },
                          ));
                        }
                      },
                    text: 'Send the Code',
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future validate(Map<String, dynamic> response, String phone) async {
    String decodedCode = utf8.decode(base64Url.decode(response['gen']));
  }
}
