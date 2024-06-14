import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;
  final Widget? iconData;
  final double width;
  final double height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final String? Function(String?)? validator;
  final Function()? onTap;

  const CustomTextFormField({
    Key? key,
    this.validator,
    this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.iconData,
    this.height = 55.0,
    this.prefixIcon,
    this.enabled = true,
    this.errorText,
    this.width = double.infinity,
    this.onTap, this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        validator: (value) {
          // Trim the value to remove leading and trailing spaces
          final trimmedValue = value?.trim();
          // Pass the trimmed value to the original validator
          if (validator != null) {
            return validator!(trimmedValue);
          }
          return null;
        },
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: errorText,
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: khintTextStyle,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          constraints: BoxConstraints(maxHeight: height, maxWidth: width),
        ),
      ),
    );
  }
}
