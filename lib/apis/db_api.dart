import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/models/saloon.dart';

final firebaseDBApiProvider = Provider((ref) {
  return FirebaseDBApi();
});

class FirebaseDBApi {
  final FirebaseFirestore _db;
  List<Saloon> allSaloons = [];

  FirebaseDBApi() : _db = FirebaseFirestore.instance;

  Future<List<Saloon>> getAllSaloons() async {
    allSaloons.clear();
    var querySnapshot = await _db.collection('saloon').get();
    log('response: ${querySnapshot.docs}');

    for (var saloon in querySnapshot.docs) {
      log('Saloon ${saloon.id}: $saloon');
      allSaloons.add(Saloon.fromFirestore(saloon));
    }

    log('all rsvps: $allSaloons');

    return allSaloons;
  }
}
