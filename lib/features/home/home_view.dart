import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/features/home/widgets/favorites_card.dart';
import 'package:saloon/features/home/widgets/salon_card.dart';
import 'package:saloon/constants/constants.dart';
import 'package:saloon/features/profile/profile_view.dart';
import 'package:saloon/models/saloon.dart';

class HomeView extends ConsumerStatefulWidget {
  final FirebaseDBApi dbApi;
  static route({required FirebaseDBApi dbApi}) => MaterialPageRoute(
      builder: (context) => HomeView(
            dbApi: dbApi,
          ));
  const HomeView({super.key, required this.dbApi});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late Future<List<Saloon>> saloonFuture;

  Future<List<Saloon>> _getAllSaloons() {
    var saloonFuture = widget.dbApi.getAllSaloons();
    return saloonFuture;
  }

  @override
  void initState() {
    super.initState();
    saloonFuture = _getAllSaloons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Love'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(ProfileView.route());
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
        elevation: 2,
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    children: [
                      Row(
                        children: [
                          Icon(LineIcons.search),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Search'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add Salon'),
                      ),
                    ],
                  ),
                ],
              ),
              regularVerticalSpacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Favorites'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 8; i++) const FavoritesCard(),
                    ],
                  ),
                ),
              ),
              regularVerticalSpacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('All'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),

              // Add a FutureBuilder here
              FutureBuilder(
                future: saloonFuture,
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
}
