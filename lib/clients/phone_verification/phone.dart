import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/phone_verification/verify.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'dart:convert';

import 'package:pragyan_cdc/provider/phone_verification_provider.dart';
import 'package:provider/provider.dart';

class PhoneNumberVerification extends StatefulWidget {
  final String otpFor;
  const PhoneNumberVerification({required this.otpFor, Key? key})
      : super(key: key);
  static String verify = "";

  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var phone = '';

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var phoneVerificationProvider = Provider.of<PhoneVerificationProvider>(
      context,
    );
    return Scaffold(
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
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "We need to register your phone before getting started!",
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
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
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
                        Expanded(
                            child: TextFormField(
                          cursorColor: Colors.black,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            phone = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              phoneVerificationProvider
                                  .setErrorMessage('Phone is required');
                            }
                            if (value.length > 10) {
                              phoneVerificationProvider.setErrorMessage(
                                  'Phone number should not exceed 10 digits');
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                      ],
                    ),
                  ),
                  Text(
                    phoneVerificationProvider.errMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
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
                                  otpFor: widget.otpFor,
                                  phone: phone,
                                  originalCode: rawCode,
                                );
                              },
                            ));
                          }
                        },
                        child: const Text("Send the code")),
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
