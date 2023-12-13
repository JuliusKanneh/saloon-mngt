import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/auth_api.dart';
import 'package:saloon/features/auth/views/login_view.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/features/home/home_view.dart';
import 'package:saloon/homepage.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/features/auth/common/common.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authApi: ref.watch(authApiProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  AuthController({required AuthApi authApi})
      : _authApi = authApi,
        super(false);

  void register({
    required UserAccount user,
    required String password,
    required BuildContext context,
  }) async {
    state = true;

    var res = await _authApi.register(user: user, password: password);

    state = false;

    res.fold(
      (l) => showSnackbar(l.message, context),
      (r) {
        log('User UID: ${r.user!.uid}');
        Navigator.of(context).push(DashboardView.route());
      },
    );
  }

  void login(String email, String password, BuildContext context) async {
    state = true;

    var res = await _authApi.login(email, password);

    state = false;

    res.fold((l) => showSnackbar(l.message, context),
        (r) => Navigator.of(context).push(HomeView.route()));
  }

  void signOut(BuildContext context) async {
    state = true;

    final res = await _authApi.signOut();

    state = false;
    res.fold(
      (l) => showSnackbar(l.message, context),
      (r) => Navigator.of(context).push(
        LoginView.route(),
      ),
    );
  }
}
