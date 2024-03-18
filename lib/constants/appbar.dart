import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

AppBar customAppBar({bool showLeading = true, String? title}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.green.shade700,
    automaticallyImplyLeading: showLeading,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    title: Text(
      title ?? '',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),
    ),
  );
}
