import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/payment/payment_success.dart';
import 'package:pragyan_cdc/model/booking_details_model.dart';

class PaymentModes extends StatelessWidget {


  const PaymentModes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Modes',
              style: kTextStyle1,
            ),
            Card(
              child: Column(
                children: [
                  kheight10,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    // padding:
                    //     const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    // margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 207, 207, 207))),
                    child: Column(children: [
                      paymentMethod(
                          " Card", "assets/images/credit-card_955066.png"),
                      paymentMethod('HDFC',
                          "assets/images/png-clipart-hdfc-logo-thumbnail-bank-logos-thumbnail.png")
                    ]),
                  ),
                  kheight10,
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 207, 207, 207))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UPI',
                          style: kTextStyle1,
                        ),
                        kheight10,
                        paymentMethod(
                            "Paypal", "assets/images/paypal_888870.png"),
                        kheight10,
                        paymentMethod("Google Pay",
                            "assets/images/google-pay_6124998.png"),
                        kheight10,
                        paymentMethod(
                            "PhonePe", "assets/images/PhonePe-Logo.png"),
                      ],
                    ),
                  ),
                  kheight10,
                  Container(
                    padding:
                        const EdgeInsets.only(left: 14, right: 14, bottom: 29),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 207, 207, 207))),
                    child: Column(
                      children: [
                        paymentMethod(
                            "Wallet", "assets/images/wallet_855279 1.png"),
                        const Text('Your Wallet amount    ₹ 0.00')
                      ],
                    ),
                  ),
                  kheight30,
                ],
              ),
            ),
            kheight30,
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(170, 40)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SuccessfulPayment()));
                    },
                    child: const Text('Pay Now')))
          ],
        ),
      ),
    );
  }
}

Widget content(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        paymentMethod(" Card", "assets/images/credit-card_955066.png"),
        const SizedBox(
          height: 30,
        ),
        const SizedBox(
          height: 30,
        ),
        paymentMethod("Google Pay", "assets/images/google-pay_6124998.png"),
        const SizedBox(
          height: 30,
        ),
        const SizedBox(
          height: 380,
        ),
      ],
    ),
  );
}

// boxShadow: [
//   BoxShadow(
//       color: Colors.grey.withOpacity(0.5),
//       spreadRadius: 2,
//       blurRadius: 5,
//       offset: const Offset(0, 3))
// ]

Widget paymentMethod(String title, String iconPath) {
  return ListTile(
    title: Text(title),
    leading: Image.asset(iconPath),
    trailing: const Icon(Icons.circle_outlined),
  );
}
