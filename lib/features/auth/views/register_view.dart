import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/features/auth/common/common_functions.dart';
import 'package:saloon/features/auth/controller/auth_controller.dart';
import 'package:saloon/features/auth/views/loading_view.dart';
import 'package:saloon/features/auth/views/login_view.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/theme/color_palette.dart';
import 'package:saloon/widgets/auth_field.dart';

class RegisterView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const RegisterView(),
      );
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final firstNameTextEditingController = TextEditingController();
  final lastNameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneNumberTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordTextEditingController = TextEditingController();
  String? selectedUserRole;
  List<String> userRoles = [
    "user",
    "manager",
  ];

  @override
  void initState() {
    super.initState();
    selectedUserRole = userRoles[0];
  }

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
                          'Sign Up',
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
                                hintText: 'Name',
                                controller: firstNameTextEditingController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AuthField(
                                hintText: 'Email',
                                controller: emailTextEditingController,
                                isEmail: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AuthField(
                                hintText: 'Enter Password',
                                controller: passwordTextEditingController,
                                isPassword: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AuthField(
                                hintText: 'Confirm Password',
                                controller:
                                    confirmPasswordTextEditingController,
                                isPassword: true,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  hintText: "Role",
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
                                // decoration: const InputDecoration(
                                //   labelText: "Manager",
                                //   border: OutlineInputBorder(
                                //     borderRadius:
                                //         BorderRadius.all(Radius.circular(20)),
                                //   ),
                                //   floatingLabelBehavior:
                                //       FloatingLabelBehavior.never,
                                // ),
                                value: userRoles[0],
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedUserRole = value;
                                  });
                                },
                                items: userRoles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  var isPassMatch = validatePassword(
                                      passwordTextEditingController.text.trim(),
                                      confirmPasswordTextEditingController.text
                                          .trim());
                                  if (!isPassMatch) {
                                    showSnackbar(
                                      'Password not match!',
                                      context,
                                    );
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    authController.register(
                                      user: UserAccount(
                                        name: firstNameTextEditingController
                                            .text
                                            .trim(),
                                        email: emailTextEditingController.text
                                            .trim(),
                                        photoUrl: "",
                                        role: selectedUserRole,
                                      ),
                                      password: passwordTextEditingController
                                          .text
                                          .trim(),
                                      context: context,
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
                                        'Register',
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
                                height: 20,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(LoginView.route());
                                },
                                child: const Text('Login Istead'),
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
