import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/firebase_options.dart';

abstract class IFirebaseApi {
  FutureEither<FirebaseApp> initializeApp();
}

final firebaseApiProvider = Provider((ref) {
  return FirebaseApi();
});

class FirebaseApi implements IFirebaseApi {
  FirebaseAuth get firebaseAuthInstance {
    return FirebaseAuth.instance;
  }

  @override
  FutureEither<FirebaseApp> initializeApp() async {
    try {
      var app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return right(app);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          message: e.message!,
          stackTrace: st,
        ),
      );
    }
  }
}
