import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/auth_api.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/features/auth/views/login_view.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/features/auth/common/common.dart';
import 'package:saloon/providers/user_account_provider.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authApi: ref.watch(authApiProvider),
    dbApi: ref.watch(firebaseDBApiProvider),
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final FirebaseDBApi _dbApi;

  AuthController({required AuthApi authApi, required dbApi})
      : _authApi = authApi,
        _dbApi = dbApi,
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
        Navigator.of(context).push(DashboardView.route(dbApi: _dbApi));
      },
    );
  }

  void login(
      {required String email,
      required String password,
      required BuildContext context,
      required WidgetRef ref}) async {
    state = true;

    var res = await _authApi.login(email, password);

    state = false;

    res.fold(
      (l) => showSnackbar(l.message, context),
      (r) {
        // update user account provider
        ref
            .watch(firebaseDBApiProvider)
            .findUserByUid(r.user!.uid)
            .then((value) {
          log('value: $value');
          ref.read(userAccountProvider).setUser(value);
        });
        Navigator.of(context).push(DashboardView.route(dbApi: _dbApi));
      },
    );
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
