import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDefaultIconLightColor,
      child: Center(
        child: SpinKitChasingDots(
          color: kPrimaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}
