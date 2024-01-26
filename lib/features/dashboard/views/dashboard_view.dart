import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/features/booking/controllers/booking_controller.dart';
import 'package:saloon/features/booking/views/booking_detail_view.dart';
import 'package:saloon/features/booking/views/booking_history_view.dart';
import 'package:saloon/features/booking/views/booking_form_view.dart';
import 'package:saloon/features/booking/views/booking_success_view.dart';
import 'package:saloon/features/home/home_view.dart';
import 'package:saloon/features/salons/controller/salon_controller.dart';
import 'package:saloon/features/salons/views/salons_view.dart';
import 'package:saloon/features/notification/view/notification_view.dart';
import 'package:saloon/features/profile/view/profile_view.dart';
import 'package:saloon/models/booking.dart';
import 'package:saloon/models/saloon.dart';

class DashboardView extends ConsumerStatefulWidget {
  final int? selectedIndex;
  final FirebaseDBApi _firebaseDBApi;
  final Salon? saloon;
  final Booking? booking;
  static route({
    /// 0 => landing page
    /// 1 => booking list view
    /// 2 => profile
    /// 3 => booking form view
    /// 4 => booking success view
    /// 5 => notification view
    /// 6 => salons view
    int? index,
    required FirebaseDBApi dbApi,
    Salon? saloon,
    Booking? booking,
  }) =>
      MaterialPageRoute(
        builder: (context) => DashboardView(
          selectedIndex: index,
          dbApi: dbApi,
          saloon: saloon,
        ),
      );
  const DashboardView({
    super.key,
    this.selectedIndex,
    required FirebaseDBApi dbApi,
    this.saloon,
    this.booking,
  }) : _firebaseDBApi = dbApi;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  late int _selectedIndex;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? 0;

    _widgetOptions = <Widget>[
      HomeView(
        dbApi: widget._firebaseDBApi,
      ),
      BookingHistoryView(
        bookingController: ref.read(bookingControllerProvider.notifier),
      ),
      const NotificationView(),
      BookingFormView(
        saloon: widget.saloon,
      ),
      const BookingSuccessView(),
      const ProfileView(),
      SalonsView(
        salonController: ref.read(salonControllerProvider.notifier),
      ),

      // This is not being used now.
      // BookingDetailView(booking: widget.booking),
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
