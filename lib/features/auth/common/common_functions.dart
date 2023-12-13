import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

String? validateTextField(value) {
  if (value == null || value.isEmpty) {
    return "Name can't be empty";
  }
  if (value.length < 2) {
    return "Please enter a valid name";
  }
  if (value.length > 50) {
    return "Name can't be more than 50";
  }
  return null;
}

String? validateEmail(email) {
  if (email == null || email.isEmpty) {
    return "Email can't be empty";
  }

  if (email.length < 2) {
    return "Please enter a valid name";
  }

  if (!EmailValidator.validate(email)) {
    return 'Invalid email';
  }

  if (email.length > 50) {
    return "Name can't be more than 50";
  }
  return null;
}

String? validatePasswordField(password) {
  if (password == null || password.isEmpty) {
    return "Name can't be empty";
  }
  if (password.length < 2) {
    return "Please enter a valid name";
  }
  if (password.length > 50) {
    return "Name can't be more than 50";
  }
  return null;
}

void showSnackbar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

bool validatePassword(String password, String confirmPassword) {
  if (password == confirmPassword) {
    return true;
  }
  return false;
}
