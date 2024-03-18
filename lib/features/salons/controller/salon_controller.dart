import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/models/saloon.dart';
import 'package:saloon/models/user_account.dart';

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

  Future<List<UserAccount>> getManagerUsers() async {
    return await _dbApi.getManagerUsers();
  }

  Future<List<String>> getMaleStylists() async {
    List<Salon> managingSalons = await _getSalonByManagerId();

    if (managingSalons.isNotEmpty) {
      return await _dbApi.getMaleStylistsBySalonId(id: managingSalons[0].id!);
    }
    return [];
  }

  Future<List<String>> getAvailableMaleStylists({
    required String salonId,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    return await _dbApi.getAvailableMaleStylists(
      salonId: salonId,
      date: date,
      time: time,
    );
  }

  Future<List<String>> getFemaleStylists() async {
    List<Salon> managingSalons = await _getSalonByManagerId();
    if (managingSalons.isNotEmpty) {
      return await _dbApi.getFemaleStylistsBySalonId(id: managingSalons[0].id!);
    }
    return [];
  }

  Future<List<String>> getAvailableFemaleStylists({
    required String salonId,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    return await _dbApi.getAvailableFemaleStylists(
      salonId: salonId,
      date: date,
      time: time,
    );
  }

  FutureEither<Salon> addSaloon(Salon saloon) async {
    log("addSaloon: $saloon");
    return await _dbApi.addSalon(saloon);
  }

  Future<List<Salon>> _getSalonByManagerId() async {
    return await _dbApi
        .getSalonByManagerId(FirebaseAuth.instance.currentUser!.uid);
  }

  FutureEither<void> addStylistToSalon({
    // required String salonId,
    required String name,
    required String gender,
  }) async {
    List<Salon> managingSalons = await _getSalonByManagerId();
    if (managingSalons.isNotEmpty) {
      return await _dbApi.addStylistToSalon(
        salonId: managingSalons[0].id!,
        name: name,
        gender: gender,
      );
    }
    return left(
      Failure(
        message: "You ar enot managing any salon",
        stackTrace: StackTrace.current,
      ),
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
