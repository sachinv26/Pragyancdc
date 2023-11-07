import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class GetOtp extends StatelessWidget {
  const GetOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Get OTP'),
      body: Padding(
        padding: const EdgeInsets.only(top: 35, left: 10, right: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Enter the OTP sent to your WhatsApp number.'),
            kheight30,
            Form(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      style: kTextStyle1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
                const OtpField(),
                const OtpField(),
                const OtpField(),
                const OtpField(),
                const OtpField(),
              ],
            )),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  'Resend OTP',
                  style: kTextStyle1,
                ),
                onPressed: () {
                  debugPrint('resend otp');
                },
              ),
            ),
            kheight60,
            kheight60,
            const CustomButton(text: 'Verify')
          ],
        ),
      ),
    );
  }
}

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: TextFormField(
          onSaved: (newValue) {},
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          style: kTextStyle1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }
}
