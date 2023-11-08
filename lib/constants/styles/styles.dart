import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/size_config.dart';

Color kPrimaryColor = const Color(0xffFC9D45);
Color kSecondaryColor = const Color(0xff573353);

final kTitle = TextStyle(
  fontFamily: 'Klasik',
  fontSize: SizeConfig.blockSizeH! * 7,
  color: kSecondaryColor,
);

const kTextStyle1 = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
const khintTextStyle =
    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 15);
const kTextStyle2 =
    TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24);
const kTextStyle3 = TextStyle(
  color: Colors.grey,
  fontSize: 13,
  fontWeight: FontWeight.bold,
);

SizedBox kheight10 = const SizedBox(
  height: 10,
);
SizedBox kheight30 = const SizedBox(
  height: 30,
);
SizedBox kheight60 = const SizedBox(
  height: 60,
);
