import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/features/auth/controller/auth_controller.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/theme/color_palette.dart';

class AuthButton extends ConsumerWidget {
  final bool isRegistrationBtn;
  final GlobalKey<FormState> formKey;
  final AuthController authController;
  final UserAccount user;
  final String password;
  const AuthButton({
    super.key,
    this.isRegistrationBtn = false,
    required this.formKey,
    required this.authController,
    required this.user,
    required this.password,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      // onTap: isRegistrationBtn ? register : login,
      onTap: () {
        if (isRegistrationBtn) {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            authController.register(
                user: user, password: password, context: context);
          }
        } else {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            authController.login(
                email: user.email!,
                password: password,
                context: context,
                ref: ref);
          }
        }
      },

      child: Container(
        width: 190,
        height: 50,
        decoration: BoxDecoration(
          color: ColorPalette.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isRegistrationBtn ? 'Register' : 'Login',
              style: const TextStyle(
                fontSize: 24,
                color: ColorPalette.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void register(BuildContext context) {
  //   if (formKey.currentState!.validate()) {
  //     authController.register(email, password, context);
  //   }
  // }

  // void login() {
  //   log('Login');
  // }
}
