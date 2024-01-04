import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/apis/firebase_api.dart';
import 'package:saloon/features/auth/views/register_view.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/firebase_options.dart';
import 'package:saloon/providers/user_account_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var firebaseApi = ref.watch(firebaseApiProvider);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('de', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: checkAuthState(firebaseApi, ref),
    );
  }
}

Widget checkAuthState(FirebaseApi firebaseApi, WidgetRef ref) {
  bool isLogIn = false;
  var currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // loadUserData(ref, currentUser);
    ref
        .watch(firebaseDBApiProvider)
        .findUserByUid(currentUser.uid)
        .then((value) {
      log('value: $value');
      ref.read(userAccountProvider).setUser(value);
    });
    isLogIn = true;
  }

  return isLogIn
      ? DashboardView(
          // pageIndex: 0,
          dbApi: ref.watch(firebaseDBApiProvider),
        )
      : const RegisterView();
}
