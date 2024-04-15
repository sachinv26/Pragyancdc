import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

AppBar customAppBar({bool showLeading = true, String? title}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent, // Making the app bar transparent
    automaticallyImplyLeading: showLeading,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(
      title ?? '',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade700, Colors.green.shade500],
        ),
      ),
    ),
  );
}