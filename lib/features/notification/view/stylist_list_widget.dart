import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/features/home/home_controller.dart';
import 'package:saloon/models/saloon.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/providers/user_account_provider.dart';

class StylistListWidget extends ConsumerStatefulWidget {
  final String stylist;
  const StylistListWidget({
    super.key,
    required this.stylist,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StylistListWidget();
}

class _StylistListWidget extends ConsumerState<StylistListWidget> {
  bool isDeleteLoading = false;
  bool addSalonLoading = false;
  final formKey = GlobalKey<FormState>();
  final salonNameController = TextEditingController();
  final salonAddressController = TextEditingController();
  final salonContactController = TextEditingController();
  final salonManagerIdTextEditingController = TextEditingController();

  /// This is used to refresh the salons_view after deleting a salon so that the deletion can be refelected.
  // void refreshMainWidget() {
  //   Navigator.of(context).push(
  //     SalonsView.route(
  //       salonController: ref.read(salonControllerProvider.notifier),
  //     ),
  //   );
  // }

  @override
  initState() {
    super.initState();
    // salonNameController.text = widget.saloon.name!;
    // salonAddressController.text = widget.saloon.address!;
    // salonContactController.text = widget.saloon.contact!;
    // salonManagerIdTextEditingController.text = widget.saloon.managerId!;
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(userAccountProvider).getUser();
    // var salonController = ref.watch(salonControllerProvider.notifier);
    var homeController = ref.watch(homeControllerProvider.notifier);

    log("Current user: ${currentUser!.email}");
    return Card(
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const ClipOval(
                  child: Icon(
                    LineIcons.user,
                    size: 50,
                  ),
                  // child: Image.asset(
                  //   "assets/banner.jpg",
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stylist,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 14,
                        ),
                      ],
                    )
                    // const Text(
                    //   "",
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 14,
                    //     color: Colors.black54,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Text("Edit"),
                        Spacer(),
                        Icon(
                          Icons.edit_note_outlined,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                    onTap: () async {
                      //TODO: show edit dialog box
                      // showSalonForm(
                      //   context: context,
                      //   logoUrl: logoUrl,
                      //   currentUser: currentUser,
                      //   homeController: homeController,
                      //   salon: widget.saloon,
                      // );
                    },
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Text("Delete"),
                        Spacer(),
                        Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    onTap: () async {
                      // show confirm delete dialog box
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text(
                              "Are you sure you want to delete this salon?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                // setState(() {
                                //   isDeleteLoading = true;
                                // });
                                // salonController
                                //     .deleteSalon(widget.saloon.id!)
                                //     .then((value) {
                                //   setState(() {
                                //     isDeleteLoading = false;
                                //     Navigator.pop(context);
                                //     refreshMainWidget();
                                //   });
                                // });
                              },
                              child: isDeleteLoading
                                  ? const CircularProgressIndicator()
                                  : const Text("Yes"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Success"),
        ),
        content: const Text("Salon Added Successfully!"),
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 50,
        ),
        actions: [
          TextButton(
            onPressed: () {
              /// navigate back to the home screen to get a fresh list of saloons
              Navigator.pop(context);
              Navigator.of(context).push(DashboardView.route(
                dbApi: ref.read(firebaseDBApiProvider),
              ));
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  Future<dynamic> showSalonForm(
      {required BuildContext context,
      String? logoUrl,
      required UserAccount? currentUser,
      required HomeController homeController,
      required Salon salon}) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Saloon'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      controller: salonNameController,
                      validator: (value) => validator(value),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Address',
                      ),
                      controller: salonAddressController,
                      validator: (value) => validator(value),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contact',
                      ),
                      controller: salonContactController,
                      validator: (value) => validator(value),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Manager Name',
                      ),
                      controller: salonManagerIdTextEditingController,
                      validator: (value) => validator(value),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // validate the form
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  setState(() {
                    addSalonLoading = true;
                  });
                },
                child: addSalonLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
