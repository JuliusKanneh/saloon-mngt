import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/features/notification/view/stylist_list_widget.dart';
import 'package:saloon/features/salons/controller/salon_controller.dart';

class FemaleStyistsWidget extends ConsumerStatefulWidget {
  // final FirebaseDBApi dbApi;
  final SalonController salonController;
  const FemaleStyistsWidget({super.key, required this.salonController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FemaleStyistsWidgetState();
}

class _FemaleStyistsWidgetState extends ConsumerState<FemaleStyistsWidget> {
  late Future<List<String>> femaleStylistFuture;

  Future<List<String>> _getFemaleStylist() {
    var femaleStylistFuture = widget.salonController.getFemaleStylists();
    return femaleStylistFuture;
  }

  @override
  void initState() {
    super.initState();
    femaleStylistFuture = _getFemaleStylist();
  }

  @override
  void didChangeDependencies() {
    // _fRsvps = widget.resvpController.getRsvpByUserIdAndStatus(
    //     userId: ref.watch(userAccountProvider).user?.id, status: "PENDING");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: femaleStylistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            log('Data received: ${snapshot.data}');
            List<String> femaleStylists = snapshot.data ?? [];
            return Column(
              children: [
                for (var femaleStylist in femaleStylists)
                  GestureDetector(
                    onTap: () async {},
                    child: StylistListWidget(
                      stylist: femaleStylist,
                    ),
                  ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
