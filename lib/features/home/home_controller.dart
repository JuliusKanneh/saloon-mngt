import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/models/saloon.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(dbApi: ref.watch(firebaseDBApiProvider));
});

class HomeController extends StateNotifier<bool> {
  final FirebaseDBApi _dbApi;
  HomeController({required FirebaseDBApi dbApi})
      : _dbApi = dbApi,
        super(false);

  Future<List<Salon>> getAllSaloons() async {
    return await _dbApi.getAllSaloons();
  }

  FutureEither<Salon> addSaloon(Salon saloon) async {
    // log("addSaloon: $saloon");
    return await _dbApi.addSalon(saloon);
  }

  Future<bool> editSalon(Salon saloon) async {
    return await _dbApi.editSalon(saloon);
  }
}
