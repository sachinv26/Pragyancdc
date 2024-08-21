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
  bool _isLoading = false;

  var phone = '';

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  void _showPhoneErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      content: Center(child: Text(message)),
      backgroundColor: Colors.green.shade800,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> result = await ApiServices()
          .generateOtp(
          mobile: phone,
          userId: '0',
          otpFor: widget.otpFor);

      setState(() {
        _isLoading = false;
      });

      print('Result is $result');

      if (result['status'] == -3) {
        _showPhoneErrorSnackBar(context, result['message']);
      } else if (result['status'] == 1) {
        final String rawCode = result['gen'];
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return VerifyNumber(
              ctx: widget.ctx,
              otpFor: widget.otpFor,
              phone: phone,
              originalCode: rawCode,
            );
          },
        ));
      } else {
        _showPhoneErrorSnackBar(context, result['message']);
      }
    }
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
                    "We need to verify your phone number before getting started!",
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
                              hintText: "Whatsapp Number",
                              errorText: null, // Remove the default error text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kheight30,
                  _isLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                    onPressed: _isLoading ? null : _sendCode,
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
