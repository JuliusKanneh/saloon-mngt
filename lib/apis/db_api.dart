import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/models/booking.dart';
import 'package:saloon/models/saloon.dart';
import 'package:saloon/models/user_account.dart';

final firebaseDBApiProvider = Provider((ref) {
  return FirebaseDBApi();
});

class FirebaseDBApi {
  final FirebaseFirestore _db;
  List<Salon> allSaloons = [];
  List<String> maleStylists = [];
  List<String> femaleStylists = [];
  List<Salon> favoriteSaloons = [];
  List<Booking> allBookings = [];

  FirebaseDBApi() : _db = FirebaseFirestore.instance;

  Future<bool> saveUserData(UserAccount user) async {
    await _db.collection('user').doc(user.id).set(user.toFireStore());
    return true;
  }

  // >>>>>>>>>>>> Salon Starts here >>>>>>>>>>>>
  Future<List<Salon>> getAllSaloons() async {
    allSaloons.clear();
    var querySnapshot = await _db.collection('saloon').get();
    log('response: ${querySnapshot.docs}');

    for (var saloon in querySnapshot.docs) {
      log('Saloon ${saloon.id}: $saloon');
      allSaloons.add(Salon.fromFirestore(saloon));
    }

    log('all rsvps: $allSaloons');

    return allSaloons;
  }

  Future<List<String>> getMaleStylistsBySalonId({required String id}) async {
    maleStylists.clear();
    var docSnapshot = await _db.collection('saloon').doc(id).get();
    Salon salon = Salon.fromFirestore(docSnapshot);
    maleStylists = salon.maleStylists!;
    log('Male Stylists: ${salon.maleStylists}');

    return maleStylists;
  }

  Future<List<String>> getFemaleStylistsBySalonId({required String id}) async {
    femaleStylists.clear();
    var docSnapshot = await _db.collection('saloon').doc(id).get();
    Salon salon = Salon.fromFirestore(docSnapshot);
    femaleStylists = salon.femaleStylists!;
    log('Female Stylists: ${salon.name}');
    log('Female Stylists: ${salon.femaleStylists}');

    return femaleStylists;
  }

  Future<List<Salon>> getFavoriteSaloons() async {
    favoriteSaloons.clear();
    var querySnapshot = await _db
        .collection('saloon')
        .where("is_favorite", isEqualTo: true)
        .get();
    log('response: ${querySnapshot.docs}');

    for (var saloon in querySnapshot.docs) {
      log('Favorite saloon ${saloon.id}: $saloon');
      favoriteSaloons.add(Salon.fromFirestore(saloon));
    }

    log('all rsvps: $allSaloons');

    return favoriteSaloons;
  }

  FutureEither<Salon> addSalon(Salon saloon) async {
    try {
      var documentReference =
          await _db.collection('saloon').add(saloon.toFirestore());
      var documentSnapshot = await documentReference.get();
      return Right(Salon.fromFirestore(documentSnapshot));
    } catch (e, st) {
      log("Error adding saloon: $e");
      return Left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  FutureEither<void> addStylistToSalon({
    required String salonId,
    required String name,
    required String gender,
  }) async {
    try {
      if (gender == "male") {
        await _db.collection('saloon').doc(salonId).update({
          "male_stylists": FieldValue.arrayUnion([name]),
        });
      } else {
        await _db.collection('saloon').doc(salonId).update({
          "female_stylists": FieldValue.arrayUnion([name]),
        });
      }
      return const Right(null);
    } catch (e, st) {
      log("Error adding saloon: $e, $st");
      return Left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  Future<bool> editSalon(Salon saloon) async {
    log("editSaloon: ID: ${saloon.id} | ${saloon.toFirestore()}");
    try {
      await _db
          .collection('saloon')
          .doc(saloon.id)
          .update(saloon.toFirestore());
      return true;
    } catch (e) {
      log("Error saving saloon: $e");
      return false;
    }
  }

  /// Delete Salon by id
  Future<void> deleteSalon(String id) async {
    // _db.collection("salon").doc("DC").delete().then(
    //   (doc) => print("Document deleted"),
    //   onError: (e) => print("Error updating document $e"),
    // );

    await _db.collection("saloon").doc(id).delete();
  }

  Future<void> updateSalonLogoUrl({
    required String photoUrl,
    required String salonId,
  }) async {
    log("updateSalonLogoUrl: $photoUrl, $salonId");
    await _db.collection('saloon').doc(salonId).update({"photo_url": photoUrl});
  }

  Future<void> updateSalonIsFavorite({
    required bool isFavorite,
    required String salonId,
  }) async {
    log("updateSalonIsFavorite: $isFavorite, $salonId");
    await _db.collection('saloon').doc(salonId).update(
      {"is_favorite": isFavorite},
    );
  }
  // >>>>>>>>>>>> Salon Ends here >>>>>>>>>>>>

  // >>>>>>>>>>>> Booking Starts here >>>>>>>>>>>>
  Future<void> addBooking(Booking booking) async {
    _db.collection('booking').add(booking.toFirestore());
  }

  // delete booking
  Future<void> deleteBooking(String id) async {
    // _db.collection("booking").doc(id).delete().then(
    //       (doc) => log("Document deleted"),
    //       onError: (e) => log("Error updating document $e"),
    //     );
    await _db.collection("booking").doc(id).delete();
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

  Future<List<Booking>> getBookingsUserId(String userId) async {
    allBookings.clear();
    var querySnapshot = await _db
        .collection('booking')
        .where("user_id", isEqualTo: userId)
        .get();
    log('response: ${querySnapshot.docs}');

    for (var booking in querySnapshot.docs) {
      log('Booking ${booking.id}: $booking');
      allBookings.add(Booking.fromFirestore(booking));
    }

    log('all bookings: $allBookings');

    return allBookings;
  }
  // >>>>>>>>>>>> Booking Ends here >>>>>>>>>>>>

  // >>>>>>>>>>>> User Starts here >>>>>>>>>>>>
  Future<UserAccount> findUserByUid(String uid) {
    return _db.collection('user').doc(uid).get().then((value) {
      log('value: $value');
      return UserAccount.fromFirestore(value);
    });
  }

  /// Update the user profile picture url to the database.
  Future<void> updateProfilePhotoUrl(String photoUrl, String userId) async {
    await _db.collection('user').doc(userId).update({"photo_url": photoUrl});
  }
  // >>>>>>>>>>>> User Ends here >>>>>>>>>>>>
}
