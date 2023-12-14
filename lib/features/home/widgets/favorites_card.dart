import 'dart:developer';

import 'package:flutter/material.dart';

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        GestureDetector(
          onTap: () {
            log('Hey');
          },
          child: Container(
            width: 155,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(right: 10),
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
                ],
              ),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   child: Container(
        //     width: 130,
        //     padding: EdgeInsets.only(left: 10),
        //     decoration: BoxDecoration(
        //       color: Colors.black87,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Column(
        //       children: [
        //         Row(
        //           children: [
        //             Text(
        //               'Moriah\'s Salon',
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 12,
        //               ),
        //             ),
        //           ],
        //         ),
        //         Row(
        //           children: [
        //             Icon(
        //               LineIcons.directions,
        //               color: Colors.white,
        //               size: 12,
        //             ),
        //             Text(
        //               'Kigali Heights',
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 12,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
