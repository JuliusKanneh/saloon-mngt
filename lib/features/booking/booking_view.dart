import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingView extends ConsumerStatefulWidget {
  const BookingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingViewState();
}

class _BookingViewState extends ConsumerState<BookingView> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController timeController =
      TextEditingController(text: 'No time selected');
  TextEditingController dateController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? gender;

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      selectableDayPredicate: (day) {
        // Disable weekend days to select from the calendar
        if (day.weekday == 6 || day.weekday == 7) {
          return false;
        }

        // Disable days before today
        return day.isAfter(DateTime.now().subtract(Duration(days: 1)));
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
    return Scaffold(
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
                    items: [
                      DropdownMenuItem(
                        value: 'Male',
                        child: const Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'Female',
                        child: const Text('Female'),
                      ),
                      DropdownMenuItem(
                        value: 'Other',
                        child: const Text('Other'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    var date = selectedDate ?? selectedDate;
                    var time = selectedTime != null
                        ? selectedTime!.format(context)
                        : 'No time selected';

                    log('Date: ${date.toString().split(' ')[0]}');
                    log('Time: ${time.toString().split(' ')[0]}');
                    log('Gender: ${time.toString().split(' ')[0]}');
                  },
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
