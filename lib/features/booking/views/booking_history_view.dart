import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/constants/constants.dart';
import 'package:saloon/features/booking/controllers/booking_controller.dart';
import 'package:saloon/features/booking/widgets/booking_history_card.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/models/booking.dart';
import 'package:saloon/providers/user_account_provider.dart';

class BookingHistoryView extends ConsumerStatefulWidget {
  final BookingController bookingController;
  const BookingHistoryView({
    super.key,
    required this.bookingController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingHistoryView();
}

class _BookingHistoryView extends ConsumerState<BookingHistoryView> {
  late Future<List<Booking>> bookingListFuture;

  /// Get bookings from database based on user role.
  /// If user is admin, get all bookings. If user is ordinary user, get bookings by user id.
  Future<List<Booking>> getBookings() {
    Future<List<Booking>> bookings = Future.value([]);
    var currentUser = ref.read(userAccountProvider).getUser();

    /// if user is not logged in, return empty list.
    /// this is just a fallback mechanism to prevent app from crashing but there must always be a logged in user.
    if (currentUser == null) {
      return bookings;
    }

    if (currentUser.role == adminUserRole) {
      bookings = widget.bookingController.getAllBookings();
    } else {
      bookings = widget.bookingController.getBookingsUserId(currentUser.id!);
    }
    return bookings;
  }

  @override
  void initState() {
    super.initState();
    bookingListFuture = getBookings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Booking History'),
          centerTitle: true,
          // backgroundColor: Colors.grey.shade100,
          elevation: 2,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                DashboardView.route(
                  dbApi: ref.read(firebaseDBApiProvider),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: bookingListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Booking> bookings = snapshot.data!;

                return bookings.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var booking in bookings)
                              BookingHistoryCard(
                                booking: booking,
                              ),
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            const Text('You haven\'t book yet. '),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Book Now'),
                            )
                          ],
                        ),
                      );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
