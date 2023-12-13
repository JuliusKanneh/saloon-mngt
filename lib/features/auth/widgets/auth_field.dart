import 'package:flutter/material.dart';
import 'package:saloon/features/auth/common/common_functions.dart';
import 'package:saloon/theme/color_palette.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final bool isEmail;
  final bool isPassword;
  final TextEditingController controller;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isEmail = false,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: ColorPalette.grey,
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: ColorPalette.blue,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: ColorPalette.blue,
              width: 3.0,
            ),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: isEmail ? validateEmail : validateTextField,
        obscureText: isPassword,
        onChanged: (value) {},
      ),
    );
  }
}
