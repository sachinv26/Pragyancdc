import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Wallet',showLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                    'assets/images/woman-doing-speech-therapy-with-little-boy-her-clinic (1) 1.png'),
                const Positioned(
                  bottom: 20,
                  right: 20,
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      'Children learn more from what you are  than what you teach',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            kheight60,
            kheight30,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/wallet_855279 1.png'),
                const SizedBox(
                  width: 7,
                ),
                const Text(
                  'Wallet',
                  style: kTextStyle1,
                ),
              ],
            ),
            kheight10,
            const Text('Your Wallet Balance    ₹ 0.00')
          ],
        ),
      ),
    );
  }
}
