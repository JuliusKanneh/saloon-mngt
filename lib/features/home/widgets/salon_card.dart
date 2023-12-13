import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/constants/constants.dart';

class SalonCard extends StatelessWidget {
  const SalonCard({
    super.key,
  });

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
                  child: Image.asset(
                    'assets/moriah.jpg',
                    fit: BoxFit.fill,
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
                    'Moriah\'s Salon',
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
                        'down town',
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
                  onPressed: () {},
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
