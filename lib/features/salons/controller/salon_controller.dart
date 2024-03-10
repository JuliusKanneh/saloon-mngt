import 'dart:developer';

import 'package:flutter/material.dart';
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

  Future<List<String>> getMaleStylists({required String salonId}) async {
    //TODO: work on assigning a salon to a manager and update this salon id to work dynamically.
    // return await _dbApi.getMaleStylistsBySalonId(id: "6jv2XDSKAAAus0Xzu7zT");
    return await _dbApi.getMaleStylistsBySalonId(id: salonId);
  }

  Future<List<String>> getAvailableMaleStylists(
      {required String salonId,
      required DateTime date, 
      required TimeOfDay time,}) async {
    return await _dbApi.getAvailableMaleStylists(
      salonId: salonId,
      date: date,
      time: time,
    );
  }

  Future<List<String>> getFemaleStylists({required String salonId}) async {
    //TODO: work on assigning a salon to a manager and update this salon id to work dynamically.
    // return await _dbApi.getFemaleStylistsBySalonId(id: "6jv2XDSKAAAus0Xzu7zT");
    return await _dbApi.getFemaleStylistsBySalonId(id: salonId);
  }

  FutureEither<Salon> addSaloon(Salon saloon) async {
    log("addSaloon: $saloon");
    return await _dbApi.addSalon(saloon);
  }

  FutureEither<void> addStylistToSalon({
    required String salonId,
    required String name,
    required String gender,
  }) async {
    return await _dbApi.addStylistToSalon(
      salonId: salonId,
      name: name,
      gender: gender,
    );
  }

  // delete booking
  Future<void> deleteSalon(String id) async {
    log("deleteSalon: $id");
    await _dbApi.deleteSalon(id);
  }

  Future<void> toggleFavorite(
      {required String salonId, required bool isFavorite}) async {
    log("toggleFavorite: $salonId | $isFavorite");
    await _dbApi.updateSalonIsFavorite(
      isFavorite: isFavorite,
      salonId: salonId,
    );
  }
}
