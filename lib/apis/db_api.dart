import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/models/booking.dart';
import 'package:saloon/models/saloon.dart';
import 'package:saloon/models/user_account.dart';

final firebaseDBApiProvider = Provider((ref) {
  return FirebaseDBApi();
});

class FirebaseDBApi {
  final FirebaseFirestore _db;
  List<Saloon> allSaloons = [];
  List<Booking> allBookings = [];

  FirebaseDBApi() : _db = FirebaseFirestore.instance;

  Future<bool> saveUserData(UserAccount user) async {
    await _db.collection('user').doc(user.id).set(user.toFireStore());
    return true;
  }

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

  Future<void> addSaloon(Saloon saloon) async {
    _db.collection('saloon').add(saloon.toFirestore());
  }

  Future<void> addBooking(Booking booking) async {
    _db.collection('booking').add(booking.toFirestore());
  }

  Future<List<Booking>> getAllBookings() async {
    allBookings.clear();
    var querySnapshot = await _db.collection('booking').get();
    log('response: ${querySnapshot.docs}');

    for (var booking in querySnapshot.docs) {
      log('Booking ${booking.id}: $booking');
      allBookings.add(Booking.fromFirestore(booking));
    }

    log('all bookings: $allBookings');

    return allBookings;
  }

  Future<UserAccount> findUserByUid(String uid) {
    return _db.collection('user').doc(uid).get().then((value) {
      log('value: $value');
      return UserAccount.fromFirestore(value);
    });
  }
}
