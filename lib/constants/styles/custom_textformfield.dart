import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;

  final Widget? iconData;
  final double width;
  final double height;
  final Widget? prefixIcon;

  const CustomTextFormField(
      {Key? key,
      this.controller,
      this.hintText = '',
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.iconData,
      this.height = 55.0,
      this.prefixIcon,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            hintText: hintText,
            hintStyle: khintTextStyle,
            prefixIcon: prefixIcon, // Change the color as needed
            suffixIcon: iconData,
            border: InputBorder.none,
            constraints: BoxConstraints(maxHeight: height, maxWidth: width)),
      ),
    );
  }
}
