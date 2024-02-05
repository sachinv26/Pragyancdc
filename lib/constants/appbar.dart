import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

AppBar customAppBar({bool showLeading = true, String? title}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    automaticallyImplyLeading: showLeading,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    title: Text(
      title ?? '',
      style: kTextStyle1,
    ),
  );
}
