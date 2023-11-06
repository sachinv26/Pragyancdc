import 'package:flutter/material.dart';
import 'package:pragyan_cdc/view/signup_selection.dart';
import 'package:pragyan_cdc/view/intro/intro_content.dart';

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
          children: const [
            IntroPage(
              imagePath: 'assets/images/13918555_5385996.png',
              text1: 'We\'re here to support your',
              text2: 'child\'s growth and development.',
            ),
            IntroPage(
                imagePath: 'assets/images/Group 10125.png',
                text1: 'Unlocking Potential, Empowering Futures:',
                text2: 'Children with Developmental Disorders'),
            IntroPage(
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
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          //padding: const EdgeInsets.all(8),
                          color: Colors.green,
                          width: 170,
                          height: 40,
                          child: const Text('Get Started'),
                        ))
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


// class _IntroductionScreenState extends State<IntroductionScreen> {
//   int currentPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller: PageController(initialPage: currentPage),
//       children: [
//         // Introduction screen 1
//         Scaffold(
//           appBar: AppBar(
//             title: Text('Introduction Screen 1'),
//           ),
//           body: Center(
//             child: Text('This is the first introduction screen.'),
//           ),
//         ),

//         // Introduction screen 2
//         Scaffold(
//           appBar: AppBar(
//             title: Text('Introduction Screen 2'),
//           ),
//           body: Center(
//             child: Text('This is the second introduction screen.'),
//           ),
//         ),

//         // Introduction screen 3
//         Scaffold(
//           appBar: AppBar(
//             title: Text('Introduction Screen 3'),
//           ),
//           body: Center(
//             child: Text('This is the third and final introduction screen.'),
//           ),
//         ),
//       ],
//     );
//   }
// }
