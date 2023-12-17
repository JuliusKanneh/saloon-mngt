import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/models/booking.dart';

final bookingControllerProvider =
    StateNotifierProvider<BookingController, bool>((ref) {
  return BookingController(dbApi: ref.watch(firebaseDBApiProvider));
});

class BookingController extends StateNotifier<bool> {
  final FirebaseDBApi _dbApi;
  BookingController({required FirebaseDBApi dbApi})
      : _dbApi = dbApi,
        super(false);

  Future<void> book(Booking booking, BuildContext context) async {
    await _dbApi.addBooking(booking);
  }

  Future<List<Booking>> getAllBookings() async {
    return await _dbApi.getAllBookings();
  }
}
