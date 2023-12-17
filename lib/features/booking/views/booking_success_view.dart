import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';

class BookingSuccessView extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BookingSuccessView(),
      );
  const BookingSuccessView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Success'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LineIcons.checkCircle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Booking Success',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(DashboardView.route(
                  index: 1,
                  dbApi: ref.watch(firebaseDBApiProvider),
                ));
              },
              child: const Text('View Booking History'),
            ),
          ],
        ),
      ),
    );
  }
}
