import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/auth_api.dart';
import 'package:saloon/features/auth/views/login_view.dart';
import 'package:saloon/providers/user_account_provider.dart';

class ProfileView extends ConsumerStatefulWidget {
  static route({required UserAccountProvider userProvider}) =>
      MaterialPageRoute(builder: (context) => const ProfileView());
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool isLoadingOnLogout = false;

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userAccountProvider).getUser();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${user?.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${user?.email}',
                    ),
                    // Add more details here like email, address, etc.
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        // set isLoadingOnLogout to true to start loading
                        setState(() {
                          isLoadingOnLogout = true;
                        });

                        var res = await ref.read(authApiProvider).signOut();

                        // set isLoadingOnLogout to false to stop loading
                        setState(() {
                          isLoadingOnLogout = false;
                        });

                        res.fold(
                          (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(failure.message),
                              ),
                            );
                          },
                          (userCredential) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Logout successful'),
                              ),
                            );
                            Navigator.of(context).push(LoginView.route());
                          },
                        );
                      },
                      child: isLoadingOnLogout
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
