import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/constants/constants.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/models/saloon.dart';

class SaloonCard extends ConsumerStatefulWidget {
  final Saloon saloon;
  const SaloonCard({
    super.key,
    required this.saloon,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SaloonCard();
}

class _SaloonCard extends ConsumerState<SaloonCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(left: 10),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 147,
                  height: 120,
                  child: Image.network(
                    widget.saloon.photoUrl ?? 'NULL',
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
            regularVerticalSpacing(),
            Container(
              width: 145,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.saloon.name ?? 'NULL',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        LineIcons.directions,
                        size: 14,
                        color: Colors.black54,
                      ),
                      Text(
                        widget.saloon.address ?? 'NULL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(DashboardView.route(
                      index: 3,
                      dbApi: ref.watch(firebaseDBApiProvider),
                    ));
                  },
                  child: const Text('Book Now'),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
