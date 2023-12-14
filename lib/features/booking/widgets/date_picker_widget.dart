import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePickerWidget extends ConsumerStatefulWidget {
  const DatePickerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DatePickerWidgetState();
}

class _DatePickerWidgetState extends ConsumerState<DatePickerWidget> {
  DateTime? selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Selected Date: ${selectedDate!.toString().split(' ')[0]}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text('Change Date'),
        ),
      ],
    );
  }
}
