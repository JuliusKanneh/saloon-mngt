import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/apis/storage_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/features/home/home_controller.dart';
import 'package:saloon/features/home/widgets/salon_card.dart';
import 'package:saloon/constants/constants.dart';
import 'package:saloon/models/saloon.dart';
import 'package:saloon/models/user_account.dart';
import 'package:saloon/providers/user_account_provider.dart';

class HomeView extends ConsumerStatefulWidget {
  final FirebaseDBApi dbApi;
  static route({
    required FirebaseDBApi dbApi,
    required HomeController homeController,
  }) =>
      MaterialPageRoute(
          builder: (context) => HomeView(
                dbApi: dbApi,
              ));
  const HomeView({
    super.key,
    required this.dbApi,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final formKey = GlobalKey<FormState>();

  final salonNameController = TextEditingController();
  final salonAddressController = TextEditingController();
  final salonContactController = TextEditingController();
  final salonManagerNameController = TextEditingController();

  bool addSalonLoading = false;
  String selectedManager = "";

  late Future<List<Salon>> saloonsFuture;
  late Future<List<Salon>> favoriteSaloonsFuture;
  late Future<List<UserAccount>> managerUserListFuture;
  Uint8List? _image;

  Future<List<Salon>> _getAllSaloons() {
    var saloonFuture = widget.dbApi.getAllSaloons();
    return saloonFuture;
  }

  Future<List<UserAccount>> _getManagerUsers() {
    var managerUserListFuture = widget.dbApi.getManagerUsers();
    return managerUserListFuture;
  }

  Future<List<Salon>> _getFavoriteSaloons() {
    var favoriteSaloonFuture = widget.dbApi.getFavoriteSaloons();
    return favoriteSaloonFuture;
  }

  Future<String> uploadSalonLogo(String fileName) async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });

    //upload image to storage and save image url to database
    var downloadUrl = await ref.watch(storeDataProvider).uploadImageToStorage(
        fileName: fileName, file: image!, folderName: "salons");
    return downloadUrl;
  }

  @override
  void initState() {
    super.initState();
    saloonsFuture = _getAllSaloons();
    favoriteSaloonsFuture = _getFavoriteSaloons();
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
          title: const Text('Wellness Love'),
          centerTitle: true,
          // backgroundColor: Colors.grey.shade100,
          elevation: 2,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  DashboardView.route(
                    index: 5,
                    dbApi: ref.read(firebaseDBApiProvider),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 10),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/banner.jpg'),
                  child: Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.white,
                  ),
                  // radius: 30,
                ),
              ),
            ),
          ],
          // centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // show the search field to search for saloons
                                // implement search and display suggestions as user types
                              },
                              icon: const Icon(LineIcons.search),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('Search'),
                          ],
                        ),
                      ],
                    ),
                    if (currentUser?.role == adminUserRole)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // show a dialog to add a saloon
                              showDialog(
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
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Name',
                                                ),
                                                controller: salonNameController,
                                                validator: (value) =>
                                                    validator(value),
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Address',
                                                ),
                                                controller:
                                                    salonAddressController,
                                                validator: (value) =>
                                                    validator(value),
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Contact',
                                                ),
                                                controller:
                                                    salonContactController,
                                                validator: (value) =>
                                                    validator(value),
                                              ),

                                              //TODO: Assign the selected user account to a salon.
                                              FutureBuilder(
                                                future: managerUserListFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.data != null) {
                                                      selectedManager = snapshot
                                                          .data![0].name!;
                                                      return DropdownButtonFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              "Select Manager",
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                        ),
                                                        value: snapshot
                                                            .data![0].id,
                                                        items: snapshot.data!
                                                            .map((UserAccount
                                                                userAccount) {
                                                          return DropdownMenuItem<
                                                              dynamic>(
                                                            value:
                                                                userAccount.id,
                                                            child: Text(
                                                                userAccount
                                                                    .name!),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (dynamic newValue) {
                                                          setState(
                                                            () {
                                                              selectedManager =
                                                                  newValue;
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
                                              //   decoration:
                                              //       const InputDecoration(
                                              //     labelText: 'Manager Name',
                                              //   ),
                                              //   controller:
                                              //       salonManagerNameController,
                                              //   validator: (value) =>
                                              //       validator(value),
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
                                                          backgroundImage:
                                                              MemoryImage(
                                                            _image!,
                                                          ),
                                                        ),
                                                  const SizedBox(width: 10),
                                                  TextButton(
                                                    onPressed: () async {
                                                      var logoUrl =
                                                          await uploadSalonLogo(
                                                              Random()
                                                                  .nextInt(
                                                                      1000000)
                                                                  .toString());
                                                      setState(() {
                                                        logoUrl = logoUrl;
                                                      });
                                                    },
                                                    child: (_image == null)
                                                        ? const Text(
                                                            "Upload Logo")
                                                        : const Text(
                                                            "Edit Logo"),
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
                                            if (!formKey.currentState!
                                                .validate()) {
                                              return;
                                            }
                                            setState(() {
                                              addSalonLoading = true;
                                            });
                                            // create a saloon object
                                            Salon saloon = Salon(
                                              name: salonNameController.text
                                                  .trim(),
                                              address: salonAddressController
                                                  .text
                                                  .trim(),
                                              contact: salonContactController
                                                  .text
                                                  .trim(),
                                              managerName:
                                                  salonManagerNameController
                                                      .text
                                                      .trim(),
                                              photoUrl: logoUrl,
                                            );

                                            // add the saloon
                                            var res = await homeController
                                                .addSaloon(saloon);
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
                                                await ref
                                                    .watch(
                                                        firebaseDBApiProvider)
                                                    .updateSalonLogoUrl(
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
                            },
                            child: const Text('Add Salon'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              regularVerticalSpacing(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Favorites'),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       DashboardView.route(
                    //         index: 6,
                    //         dbApi: ref.read(firebaseDBApiProvider),
                    //       ),
                    //     );
                    //   },
                    //   child: const Text('View All'),
                    // ),
                  ],
                ),
              ),
              regularVerticalSpacing(),
              FutureBuilder(
                future: favoriteSaloonsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data != null
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var saloon in snapshot.data!)
                                    SaloonCard(
                                      saloon: saloon,
                                    ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: const Text('No Data'),
                          );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width - 30,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       children: [
              //         for (int i = 0; i < 8; i++) const FavoritesCard(),
              //       ],
              //     ),
              //   ),
              // ),
              regularVerticalSpacing(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('All'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          DashboardView.route(
                            index: 6,
                            dbApi: ref.read(firebaseDBApiProvider),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),

              FutureBuilder(
                future: saloonsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data != null
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var saloon in snapshot.data!)
                                    SaloonCard(
                                      saloon: saloon,
                                    ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: const Text('No Data'),
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
    );
  }

  /// bringing this function here to avoid using the build context within an async function
  showSuccessDialog(bool isSaved) {
    showAlertDialog(
      title: isSaved ? "Success" : "Failure",
      content: isSaved
          ? "Saloon added successfully"
          : "Failed to add salon! Please try again. If it persists, contact support.",
      context: context,
      ref: ref,
    );
  }
}
