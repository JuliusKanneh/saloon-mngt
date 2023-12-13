import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/features/booking/booking_history_view.dart';
import 'package:saloon/features/home/home_view.dart';
import 'package:saloon/features/profile/profile_view.dart';

class DashboardView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const DashboardView(),
      );
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    // _selectedIndex = widget.pageIndex;

    _widgetOptions = <Widget>[
      const HomeView(),
      const BookingHistoryView(),
      const ProfileView(),
      // routeToBookDetails(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black, // navigation bar padding,
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.save,
                    text: 'Bookings',
                  ),
                  GButton(
                    icon: Icons.notifications_none_outlined,
                    text: 'Notifications',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  // route(index);
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
