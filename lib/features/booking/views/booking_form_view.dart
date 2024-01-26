import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/features/booking/controllers/booking_controller.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/models/booking.dart';
import 'package:saloon/models/saloon.dart';
import 'package:saloon/providers/user_account_provider.dart';

class BookingFormView extends ConsumerStatefulWidget {
  final Salon? saloon;
  const BookingFormView({super.key, required this.saloon});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingViewState();
}

class _BookingViewState extends ConsumerState<BookingFormView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController timeController =
      TextEditingController(text: 'No time selected');
  TextEditingController dateController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? gender;
  String? style;
  bool isLoading = false;

  String selectedGender = 'male';
  List<String> maleStyles = ['Male Style 1', 'Male Style 2', 'Male Style 3'];
  List<String> femaleStyles = [
    'Female Style 1',
    'Female Style 2',
    'Female Style 3'
  ];
  List<String> currentStyles = [];

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,

      /// The initial date for the booking view.
      /// If the current day is Saturday (weekday == 6), the initial date will be two days ahead.
      /// Otherwise, the initial date will be one day ahead of the current date.
      //TODO: Uncomment the code below to enable the initial date to be two days ahead of the current date if the current day is Saturday.
      // initialDate: DateTime.now().weekday == 6
      //     ? DateTime.now().add(const Duration(days: 2))
      //     : DateTime.now().add(const Duration(days: 1)),

      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      selectableDayPredicate: (day) {
        // Disable weekend days to select from the calendar
        //TODO: Uncomment to disable weekend days to select from the calendar
        // if (day.weekday == 6 || day.weekday == 7) {
        //   return false;
        // }

        // Disable days before today
        return day.isAfter(DateTime.now().subtract(
          const Duration(days: 1),
        ));
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Booking'),
          centerTitle: true,
          elevation: 8.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: InputBorder.none,
                      ),
                      onTap: () => _showDatePicker(context),
                      readOnly: true,
                      controller: TextEditingController(
                        text: selectedDate != null
                            ? selectedDate.toString()
                            : 'No date selected',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value == 'No date selected') {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        border: InputBorder.none,
                      ),
                      onTap: () => _showTimePicker(context),
                      readOnly: true,
                      controller: TextEditingController(
                        text: selectedTime != null
                            ? selectedTime!.format(context)
                            : 'No time selected',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value == 'No time selected') {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: InputBorder.none,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                        // DropdownMenuItem(
                        //   value: 'Other',
                        //   child: Text('Other'),
                        // ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        log("value: $value");
                        setState(() {
                          gender = value;
                          selectedGender = value!;
                          updateStyleDropdown();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: currentStyles.isNotEmpty ? currentStyles[0] : null,
                      decoration: const InputDecoration(
                        labelText: 'Style',
                        border: InputBorder.none,
                      ),
                      items: currentStyles.map((String style) {
                        return DropdownMenuItem<String>(
                          value: style,
                          child: Text(style),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          style = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // var date = selectedDate != null
                      //     ? selectedDate!.toString().split(' ')[0]
                      //     : 'No date selected';
                      // var time = selectedTime != null
                      //     ? selectedTime!.format(context)
                      //     : 'No time selected';

                      // log('Time: ${selectedTime.toString().substring(10, 15)}');

                      // log('Date: ${date.toString().split(' ')[0]}');
                      // log('Time: ${time.toString().split(' ')[0]}');
                      // log('Gender: $gender');

                      Booking booking = Booking(
                        userId: ref.watch(userAccountProvider).user!.id,
                        saloonId: widget.saloon!.id,
                        date: selectedDate,
                        time: selectedTime,
                        gender: gender,
                        style: style,
                        status: 'Pending',
                      );

                      log('Booking: ${booking.toFirestore()}');

                      // check if the form is valid
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      // save booking to database
                      isLoading = true;

                      await ref
                          .watch(bookingControllerProvider.notifier)
                          .book(booking, context);

                      isLoading = false;
                      routeToBookingSuccess();
                    },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Book Now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateStyleDropdown() {
    setState(() {
      if (selectedGender == 'male') {
        currentStyles = List.from(maleStyles);
      } else if (selectedGender == 'female') {
        currentStyles = List.from(femaleStyles);
      }
    });
  }

  void routeToBookingSuccess() {
    Navigator.of(context).push(DashboardView.route(
      index: 4,
      dbApi: ref.watch(firebaseDBApiProvider),
      saloon: widget.saloon,
    ));
  }
}
