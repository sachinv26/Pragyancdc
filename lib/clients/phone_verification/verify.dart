import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:pragyan_cdc/api/login_api.dart';
import 'package:pragyan_cdc/clients/client_login/signup.dart';
import 'package:pragyan_cdc/clients/phone_verification/phone.dart';
import 'dart:convert';

class VerifyNumber extends StatefulWidget {
  String originalCode;
  String phone;
  VerifyNumber({required this.phone, required this.originalCode, Key? key})
      : super(
          key: key,
        );
  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  late String decoded;
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

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";

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
                  code = value;
                },
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                //  onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
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
                          otpFor: '1',
                          otpCode: code);
                      print('response : $response');
                      // Create a PhoneAuthCredential with the code
                      // try {
                      // PhoneAuthCredential credential =
                      //     PhoneAuthProvider.credential(
                      //         verificationId: MyPhone.verify, smsCode: code);

                      // // Sign the user in (or link) with the credential
                      // await auth.signInWithCredential(credential);

                      //   Navigator.of(context).pushAndRemoveUntil(
                      //       MaterialPageRoute(
                      //     builder: (context) {
                      //       return ClientSignUp(phoneNumber: widget.phone);
                      //     },
                      //   ), (route) => false);
                      // } catch (e) {
                      //   debugPrint('Exception wrong otp $e');
                      // }
                    },
                    child: const Text("Verify Phone Number")),
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
