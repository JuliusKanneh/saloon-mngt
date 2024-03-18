import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/features/notification/view/stylist_list_widget.dart';
import 'package:saloon/features/salons/controller/salon_controller.dart';

class MaleStyistsWidget extends ConsumerStatefulWidget {
  // final FirebaseDBApi dbApi;
  final SalonController salonController;
  const MaleStyistsWidget({super.key, required this.salonController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MaleStyistsWidgetState();
}

class _MaleStyistsWidgetState extends ConsumerState<MaleStyistsWidget> {
  late Future<List<String>> maleStylistFuture;

  Future<List<String>> _getMaleStylist() {
    var maleStylistFuture = widget.salonController.getMaleStylists();
    return maleStylistFuture;
  }

  @override
  void initState() {
    super.initState();
    maleStylistFuture = _getMaleStylist();
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
        future: maleStylistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            log('Data received: ${snapshot.data}');
            List<String> maleStylists = snapshot.data ?? [];
            return Column(
              children: [
                for (var maleStylist in maleStylists)
                  GestureDetector(
                    onTap: () async {},
                    child: StylistListWidget(
                      stylist: maleStylist,
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
