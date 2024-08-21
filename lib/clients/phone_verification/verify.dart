import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/auth_wrapper.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/clients/client_login/signup.dart';
import 'package:pragyan_cdc/clients/phone_verification/forgot_password.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
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
      Key? key,})
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

  final TextEditingController _otpController = TextEditingController();


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
    // print(widget.userid);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar(title: 'Phone Verification'),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter the OTP sent to your phone!",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                decoded,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                controller: _otpController,
                length: 6,
                onChanged: (value) {
                  code = value;
                },
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () async {
                        final response = await ApiServices().generateOtp(
                            mobile: widget.phone, userId: '0', otpFor: widget.otpFor);
                        if (response['status'] == 1) {
                          setState(() {
                            widget.originalCode = response['gen'];
                            decoded = decode64(widget.originalCode);
                            _otpController.clear();
                          });
                          print('successfully generated');
                        } else {
                          setState(() {
                            errMessage = response['message'];
                          });
                        }
                      },
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                            color: Colors.green.shade600,
                            ),
                      ))),
              kheight30,
              SizedBox(
                height: 45,
                child: CustomButton(
                  text: 'Verify Phone Number',
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return ClientSignUp(phoneNumber: widget.phone);
                          },
                        ));
                      }else if( widget.otpFor =='3') {
                        //otpfor is 2, for forgot password
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //   builder: (context) {
                        //     return AuthWrapper(
                        //     );
                        //   },
                        // ));
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      } else {
                        //otpfor is 2, for forgot password
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                ),
              ),
              kheight10,
              Text(
                errMessage,
                style: const TextStyle(color: Colors.red),
              ),
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
