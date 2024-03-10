import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/constants/constants.dart';
import 'package:saloon/features/salons/controller/salon_controller.dart';
import 'package:saloon/features/stylists/views/stylists_widgets.dart';
import 'package:saloon/providers/user_account_provider.dart';

//TODO: rename this widget
class NotificationView extends ConsumerStatefulWidget {
  final SalonController salonController;
  const NotificationView({super.key, required this.salonController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {
  late Future<List<String>> maleStylistFuture;
  late Future<List<String>> femaleStylistFuture;

  Future<List<String>> _getMaleStylist() {
    var maleStylistFuture =
        widget.salonController.getMaleStylists(salonId: "6jv2XDSKAAAus0Xzu7zT");
    return maleStylistFuture;
  }

  @override
  void initState() {
    super.initState();
    maleStylistFuture = _getMaleStylist();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(userAccountProvider).getUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentUser!.role != managerUserRole
          ? Scaffold(
              appBar: AppBar(
                title: const Text('Notifications'),
                centerTitle: true,
                elevation: 2,
                // backgroundColor: Colors.grey.shade100,
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 100,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : StylistsWidget(maleStylistFuture: maleStylistFuture),
    );
  }
}
