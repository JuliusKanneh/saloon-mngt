import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/features/booking/controllers/booking_controller.dart';
import 'package:saloon/features/booking/views/payment_link_web_view.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/models/booking.dart';

class BookingHistoryCard extends ConsumerStatefulWidget {
  final Booking booking;
  const BookingHistoryCard({
    super.key,
    required this.booking,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BookingHistoryCardState();
  }
}

class _BookingHistoryCardState extends ConsumerState<BookingHistoryCard> {
  bool isLoading = false;

  showScaffoldMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // duration: const Duration(seconds: 1),
      ),
    );

    // Navigate back to Booking History View
    Navigator.of(context).push(
      DashboardView.route(
        index: 1,
        dbApi: ref.read(firebaseDBApiProvider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   DashboardView.route(
        //     index: 6,
        //     booking: widget.booking,
        //     dbApi: ref.read(firebaseDBApiProvider),
        //   ),
        // );
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(
              'ID: ${widget.booking.id}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Booking Date: ${widget.booking.date}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Booking Time: ${widget.booking.time.toString().substring(10, 15)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Payment Status: ${widget.booking.status}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to Stripe Payment Link WebView
                        Navigator.of(context).push(
                          PaymentLinkView.route(),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text("Pay"),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        await ref
                            .read(bookingControllerProvider.notifier)
                            .deleteBooking(widget.booking.id!);

                        setState(() {
                          isLoading = false;
                        });

                        showScaffoldMessage(
                          'Booking Cancelled',
                        );
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
