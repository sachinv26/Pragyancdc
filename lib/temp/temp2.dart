import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  final List<String> imgList = [
    'assets/images/children.png',
    'assets/images/children-learning-globe-with-woman-bedroom 1.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imgList
                  .map((item) => Container(
                child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(item, fit: BoxFit.cover, width: 1000),
                          Positioned(
                            left: 8,
                            top: 10,
                            child: Image.asset(
                              'assets/images/Pragyan-Logo-New__1_-removebg-preview 1.png',
                            ),
                          ),
                          Positioned(
                            top: 40,
                            child: SizedBox(
                              width: 250,
                              child: Text(
                                'Children learn more from what you are than what you teach',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ))
                  .toList(),
            ),
          ),
          // Your other widgets go here
        ],
      ),
    );
  }
}