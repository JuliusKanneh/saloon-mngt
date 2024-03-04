import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/apis/firebase_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/providers/user_account_provider.dart';

abstract class IAuthApi {
  FutureEither<UserCredential> register({
    required UserAccount user,
    required String password,
  });
  FutureEither<UserCredential> login(String email, String password);
  FutureEither<void> signOut();
}

final authApiProvider = Provider((ref) {
  return AuthApi(
    firebaseApi: ref.watch(firebaseApiProvider),
    userAccountProvider: ref.watch(userAccountProvider),
    firebaseDBApi: ref.watch(firebaseDBApiProvider),
  );
});

class AuthApi implements IAuthApi {
  final FirebaseApi firebaseApi;
  final UserAccountProvider userAccountProvider;
  final FirebaseDBApi firebaseDBApi;

  AuthApi({
    required this.firebaseApi,
    required this.userAccountProvider,
    required this.firebaseDBApi,
  });

  @override
  FutureEither<UserCredential> register({
    required UserAccount user,
    required String password,
  }) async {
    try {
      final userCredential =
          await firebaseApi.firebaseAuthInstance.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );

      // set the user id and role before saving
      user.setId(userCredential.user!.uid);
      // user.setRole(ordinaryUserRole);

      // save user data
      var saveUserData = await firebaseDBApi.saveUserData(user);
      if (userCredential.user != null && saveUserData) {
        log('successful signup');
        userAccountProvider.setUser(user);
        return right(userCredential);
      } else {
        return left(
          Failure(message: 'Error', stackTrace: StackTrace.current),
        );
      }
    } on FirebaseAuthException catch (e, st) {
      log('error message: ${e.message}\nStacktrace: $st');
      return left(
        Failure(message: e.message!, stackTrace: st),
      );
    }
  }

  @override
  FutureEither<UserCredential> login(String email, String password) async {
    try {
      final userCredential = await firebaseApi.firebaseAuthInstance
          .signInWithEmailAndPassword(email: email, password: password);

      // retrieve driver data
      // var driver =
      //     await firebaseDBApi.findDriverByUid(userCredential.user!.uid);

      //set the userAccountProvider with it
      // userAccountProvider.setDriver(driver);
      return right(userCredential);
    } on FirebaseAuthException catch (e, st) {
      return left(
        Failure(message: e.message!, stackTrace: st),
      );
    }
  }

  @override
  FutureEither<void> signOut() async {
    try {
      await firebaseApi.firebaseAuthInstance.signOut();
      return right(null);
    } on FirebaseAuthException catch (e, st) {
      return left(
        Failure(message: e.message!, stackTrace: st),
      );
    }
  }
}
