import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/models/saloon.dart';

final salonControllerProvider =
    StateNotifierProvider<SalonController, bool>((ref) {
  return SalonController(dbApi: ref.watch(firebaseDBApiProvider));
});

class SalonController extends StateNotifier<bool> {
  final FirebaseDBApi _dbApi;
  SalonController({required FirebaseDBApi dbApi})
      : _dbApi = dbApi,
        super(false);

  Future<List<Salon>> getAllSaloons() async {
    return await _dbApi.getAllSaloons();
  }

  FutureEither<Salon> addSaloon(Salon saloon) async {
    log("addSaloon: $saloon");
    return await _dbApi.addSalon(saloon);
  }

  // delete booking
  Future<void> deleteSalon(String id) async {
    log("deleteSalon: $id");
    await _dbApi.deleteSalon(id);
  }
}
