import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/models/booking.dart';

class BookingDetailView extends ConsumerStatefulWidget {
  final Booking? booking;

  static route({required Booking? booking}) => MaterialPageRoute(
      builder: (context) => BookingDetailView(
            booking: booking,
          ));
  const BookingDetailView({super.key, required this.booking});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingDetailViewState();
}

class _BookingDetailViewState extends ConsumerState<BookingDetailView> {
  // late final Future<PaymentConfiguration> _googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 2,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'Booking Details',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 15),
          const Text(
            'Card Form',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Pay'),
          )
        ],
      ),
    );
  }
}
