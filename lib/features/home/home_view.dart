import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/features/home/widgets/favorites_card.dart';
import 'package:saloon/features/home/widgets/salon_card.dart';
import 'package:saloon/constants/constants.dart';
import 'package:saloon/features/profile/profile_view.dart';

class HomeView extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Love'),
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
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 8; i++) const SalonCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
