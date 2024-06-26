import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/apis/storage_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/features/home/home_controller.dart';
import 'package:saloon/features/salons/controller/salon_controller.dart';
import 'package:saloon/features/salons/widgets/salon_list_widget.dart';
import 'package:saloon/models/saloon.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/providers/user_account_provider.dart';

class SalonsView extends ConsumerStatefulWidget {
  final SalonController salonController;
  static route({required SalonController salonController}) => MaterialPageRoute(
        builder: (context) => SalonsView(
          salonController: salonController,
        ),
      );
  const SalonsView({super.key, required this.salonController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalonsViewState();
}

class _SalonsViewState extends ConsumerState<SalonsView> {
  late Future<List<Salon>> saloonFuture;
  late Future<List<UserAccount>> managerUserListFuture;
  bool addSalonLoading = false;
  final formKey = GlobalKey<FormState>();
  final salonNameController = TextEditingController();
  final salonAddressController = TextEditingController();
  final salonContactController = TextEditingController();
  // final salonManagerIdTextEditingController = TextEditingController();
  Uint8List? _image;
  String? logoUrl;
  String selectedManagerId = "";

  Future<List<Salon>> _getAllSaloons() {
    var saloonFuture = widget.salonController.getAllSaloons();
    return saloonFuture;
  }

  Future<List<UserAccount>> _getManagerUsers() {
    var managerUserListFuture = widget.salonController.getManagerUsers();
    return managerUserListFuture;
  }

  Future<void> getPhotoFromGallery() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });

    //upload image to storage and save image url to database
    // var downloadUrl = await ref.watch(sotreDataProvider).uploadImageToStorage(
    //     fileName: salonId, file: image!, folderName: "salon");

    // return downloadUrl;
  }

  @override
  void initState() {
    super.initState();
    saloonFuture = _getAllSaloons();
    managerUserListFuture = _getManagerUsers();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(userAccountProvider).getUser();
    var homeController = ref.watch(homeControllerProvider.notifier);
    String logoUrl = "";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Salons'),
        ),
        body: SingleChildScrollView(
          child: Container(
            // padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                ///TODO: uncomment this code to add new salon
                Row(
                  children: [
                    const Icon(Icons.sort_by_alpha_sharp),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    TextButton(
                      onPressed: () {
                        // show the dialog
                        showSalonForm(
                          context,
                          logoUrl,
                          currentUser,
                          homeController,
                        );
                      },
                      child: const Text("Add"),
                    )
                  ],
                ),

                // List of salons here
                FutureBuilder(
                  future: saloonFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width - 30,
                              child: SingleChildScrollView(
                                // scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    for (var saloon in snapshot.data!)
                                      SalonListWidget(saloon: saloon),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width - 30,
                              child: const Text('No Salon Found'),
                            );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showSalonForm(
    BuildContext context,
    String? logoUrl,
    UserAccount? currentUser,
    HomeController homeController,
  ) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Salon'),
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

                    // Assigning manager to the salon from the list of registered manager users.
                    FutureBuilder(
                      future: managerUserListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data != null) {
                            return DropdownButtonFormField(
                              decoration: const InputDecoration(
                                hintText: "Select Manager",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                              items:
                                  snapshot.data!.map((UserAccount userAccount) {
                                return DropdownMenuItem<dynamic>(
                                  value: userAccount.id,
                                  child: Text(userAccount.name!),
                                );
                              }).toList(),
                              onChanged: (dynamic newValue) {
                                log('Dropdown value: $newValue');
                                setState(
                                  () {
                                    selectedManagerId = newValue;
                                  },
                                );
                                // print(controller.roleLabel.value);
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),

                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //     labelText: 'Manager Name',
                    //   ),
                    //   controller: salonManagerIdTextEditingController,
                    //   validator: (value) => validator(value),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        (_image == null)
                            ? const Icon(
                                Icons.image,
                                size: 50,
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundImage: MemoryImage(
                                  _image!,
                                ),
                              ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () async {
                            await getPhotoFromGallery();
                          },
                          child: (_image == null)
                              ? const Text("Upload Logo")
                              : const Text("Edit Logo"),
                        ),
                      ],
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

                  // create a saloon object
                  Salon saloon = Salon(
                    name: salonNameController.text.trim(),
                    address: salonAddressController.text.trim(),
                    contact: salonContactController.text.trim(),
                    managerId: selectedManagerId,
                    photoUrl: logoUrl,
                  );

                  // add the saloon
                  var res = await homeController.addSaloon(saloon);
                  res.fold((l) {
                    setState(() {
                      addSalonLoading = false;
                    });
                    showSuccessDialog(false);
                  }, (r) {
                    //upload image to storage and save image url to database
                    ref
                        .watch(storeDataProvider)
                        .uploadImageToStorage(
                          fileName: r.id!,
                          file: _image!,
                          folderName: "SalonLogos",
                        )
                        .then((value) async {
                      //update salon logo url
                      await ref.watch(firebaseDBApiProvider).updateSalonLogoUrl(
                            photoUrl: value,
                            salonId: r.id!,
                          );
                    });
                    setState(() {
                      addSalonLoading = false;
                    });
                    showSuccessDialog(true);
                  });
                },
                child: addSalonLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void showSuccessDialog(bool isSaved) {
    showAlertDialog(
      title: isSaved ? "Success" : "Failure",
      content: isSaved
          ? "Saloon added successfully"
          : "Failed to add saloon! Please try again. If it persists, contact support.",
      context: context,
      ref: ref,
    );
  }
}
