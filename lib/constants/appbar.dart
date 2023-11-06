import 'package:flutter/material.dart';

AppBar myAppBar({bool showLeading = true, String? title}) {
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: showLeading,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    title: Text(title ?? ''),
    centerTitle: true,
  );
}
