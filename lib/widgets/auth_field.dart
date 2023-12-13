import 'package:flutter/material.dart';

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
      height: 45,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              // color: Colors.blue,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 3.0,
            ),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // validator: isEmail ? validateEmail : validateTextField,
        obscureText: isPassword,
        onChanged: (value) {},
      ),
    );
  }
}
