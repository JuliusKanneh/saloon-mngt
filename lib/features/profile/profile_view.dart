import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saloon/features/auth/views/login_view.dart';
import 'package:saloon/homepage.dart';

class ProfileView extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ProfileView());
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(HomePage.route());
                },
                child: const Text('Show previous home screen'),
              ),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(LoginView.route());
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
