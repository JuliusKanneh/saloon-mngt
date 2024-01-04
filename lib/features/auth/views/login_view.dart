import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/features/auth/controller/auth_controller.dart';
import 'package:saloon/features/auth/views/loading_view.dart';
import 'package:saloon/features/auth/views/register_view.dart';
import 'package:saloon/theme/color_palette.dart';
import 'package:saloon/widgets/auth_field.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    var authController = ref.watch(authControllerProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const LoadingView()
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Wellness Love',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AuthField(
                                hintText: 'Enter Username',
                                controller: emailTextEditingController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              AuthField(
                                hintText: 'Enter Password',
                                controller: passwordTextEditingController,
                                isPassword: true,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    authController.login(
                                      email: emailTextEditingController.text
                                          .trim(),
                                      password: passwordTextEditingController
                                          .text
                                          .trim(),
                                      context: context,
                                      ref: ref,
                                    );
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: ColorPalette.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: ColorPalette.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    RegisterView.route(),
                                  );
                                },
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
