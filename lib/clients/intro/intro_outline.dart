import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/clients/intro/intro_content.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  //keep  track of we are on the last page
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          controller: _controller,
          children: [
            IntroPage(
              imagePath: 'assets/images/13918555_5385996.png',
              text1: 'We\'re here to support your',
              text2: 'child\'s growth and development.',
              showSkipButton: true,
              onSkipPressed: () {
                Navigator.pushReplacementNamed(context, '/signupSelection');
              },
              controller: _controller, // Pass the PageController
            ),
            const IntroPage(
                imagePath: 'assets/images/Group 10125.png',
                text1: 'Unlocking Potential, Empowering Futures:',
                text2: 'Children with Developmental Disorders'),
            const IntroPage(
                imagePath: 'assets/images/Group.png',
                text1: 'Accessible Excellence: Empowering',
                text2: 'Every Child\'s Potential')
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 115,
            // Adjust the value as needed
            child: Column(
              children: [
                SmoothPageIndicator(
                  effect: const SlideEffect(
                      activeDotColor: Colors.green, dotColor: Colors.grey),
                  controller: _controller,
                  count: 3,
                ),
                const SizedBox(
                  height: 50,
                ),
                onLastPage
                    ? CustomButton(
                        text: 'Get Started',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/signupSelection');
                        },
                      )
                    : Align(
                        alignment: const Alignment(1, 1),
                        child: GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: const CircleAvatar(
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      )
              ],
            )),
      ],
    ));
  }
}
