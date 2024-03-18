import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:saloon/features/salons/controller/salon_controller.dart';
import 'package:saloon/features/stylists/widgets/female_stylists_widget.dart';
import 'package:saloon/features/stylists/widgets/male_stylists_widget.dart';

class StylistsWidget extends ConsumerStatefulWidget {
  const StylistsWidget({
    super.key,
    required this.maleStylistFuture,
  });

  final Future<List<String>> maleStylistFuture;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StylistsWidgetState();
}

class _StylistsWidgetState extends ConsumerState<StylistsWidget> {
  AnimatedButtonController controller = AnimatedButtonController();
  TextEditingController nameTextEditiingController = TextEditingController();
  String gender = "female";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sylists'),
        centerTitle: true,
        elevation: 2,
        // backgroundColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    color: Colors.blue.shade100,
                    iconSize: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //show dialog box
                      showBottomSheet(
                        context: context,
                        elevation: 20,
                        backgroundColor: Colors.grey.shade100,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            height: 320,
                            child: Column(
                              children: [
                                const Text(
                                  'Add Stylist',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: nameTextEditiingController,
                                  decoration: const InputDecoration(
                                    labelText: 'Stylist Name',
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DropdownButtonFormField(
                                  items: const [
                                    DropdownMenuItem(
                                      value: "male",
                                      child: Text('male'),
                                    ),
                                    DropdownMenuItem(
                                      value: "female",
                                      child: Text('female'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText:
                                        "Select stylist type (male/female)",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    //add the stylist to the salon list based on the type(gender)
                                    var res = await ref
                                        .watch(salonControllerProvider.notifier)
                                        .addStylistToSalon(
                                          //TODO: to be fixed -using Precious Salon for testing now
                                          // salonId: "6jv2XDSKAAAus0Xzu7zT",
                                          name: nameTextEditiingController.text,
                                          gender: gender,
                                        );
                                    res.fold(
                                      (l) => print(l.message),
                                      (r) {
                                        print("Stylist added successfully");
                                        Navigator.pop(context);
                                        //show success message
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text("Add"),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedButtonBar(
                controller: controller,
                radius: 8.0,
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.lightBlue,
                padding: const EdgeInsets.all(16.0),
                invertedSelection: true,
                children: [
                  ButtonBarEntry(
                    onTap: () => setState(() {
                      controller.setIndex(0);
                    }),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Male Stylists'),
                        Icon(Icons.man),
                      ],
                    ),
                  ),
                  ButtonBarEntry(
                    onTap: () => setState(() {
                      controller.setIndex(1);
                    }),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Female Stylists'),
                        Icon(
                          Icons.woman,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 460),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: MediaQuery.of(context).size.width - 40,
                child: renderTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderTabContent() {
    switch (controller.index) {
      case 0:
        return MaleStyistsWidget(
            salonController: ref.read(salonControllerProvider.notifier));
      case 1:
        return FemaleStyistsWidget(
            salonController: ref.read(salonControllerProvider.notifier));
      default:
        return Container();
    }
  }
}
