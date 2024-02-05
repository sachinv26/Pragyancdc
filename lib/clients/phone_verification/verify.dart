import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/client_login/signup.dart';
import 'package:pragyan_cdc/clients/phone_verification/forgot_password.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class VerifyNumber extends StatefulWidget {
  final String otpFor;
  String originalCode;
  String phone;
  BuildContext ctx;
  VerifyNumber(
      {required this.otpFor,
      required this.ctx,
      required this.phone,
      required this.originalCode,
      Key? key})
      : super(
          key: key,
        );
  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  late String decoded;
  var code = "";
  String errMessage = '';
  // final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    decoded = decode64(widget.originalCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
    //   borderRadius: BorderRadius.circular(8),
    // );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration?.copyWith(
    //     color: const Color.fromRGBO(234, 239, 243, 1),
    //   ),
    // );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter the OTP sent to your phone!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              Text(decoded),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                onChanged: (value) {
                  //  print(value);
                  code = value;
                },
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                //  onCompleted: (pin) => print(pin),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () async {
                        final response = await ApiServices().generateOtp(
                            mobile: widget.phone, userId: '0', otpFor: '1');
                        // final status = response['status'];
                        // print('status is $status');
                        if (response['status'] == 1) {
                          setState(() {
                            widget.originalCode = response['gen'];
                            decoded = decode64(widget.originalCode);
                          });
                          print('successfully generated');
                        } else {
                          setState(() {
                            errMessage = response['message'];
                          });
                        }
                      },
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ))),
              kheight30,
              SizedBox(
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      final response = await ApiServices().validateOtp(
                          mobile: widget.phone,
                          userId: '0',
                          otpFor: widget.otpFor,
                          otpCode: code);
                      print('response : $response');
                      if (response['status'] == 1) {
                        Fluttertoast.showToast(
                          msg: 'OTP Verified Successfully!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                        if (widget.otpFor == '1') {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) {
                              return ClientSignUp(phoneNumber: widget.phone);
                            },
                          ));
                        } else {
                          //otpfor is 2, for forgot password
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) {
                              return ForgotPassword(
                                ctx: widget.ctx,
                                phone: widget.phone,
                              );
                            },
                          ));
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Failed to verify OTP. Please try again.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    child: const Text("Verify Phone Number")),
              ),
              kheight10,
              Text(
                errMessage,
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  String decode64(String code) {
    String decodedCode = utf8.decode(base64Url.decode(code));
    return decodedCode;
  }
}
