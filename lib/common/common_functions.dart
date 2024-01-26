import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/features/dashboard/views/dashboard_view.dart';
import 'package:saloon/features/salons/controller/salon_controller.dart';

/// Shows an alert dialog with the given [title] and [content].
/// When the dialog is dismissed, it navigates back to the home screen.
/// If [ref] is provided, it will also refresh the list of saloons.
/// If [ref] is not provided, it will not refresh the list of saloons.
void showAlertDialog(
    {required String title,
    required String content,
    required BuildContext context,
    WidgetRef? ref}) {
  // first dismiss the previous dialog
  Navigator.of(context).pop();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(
        child: Text(title),
      ),
      content: Text(content),
      icon: title == "Success"
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            )
          : const Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            ),
      actions: [
        TextButton(
            onPressed: () {
              /// navigate back to the home screen to get a fresh list of saloons
              if (ref != null) {
                Navigator.pop(context);
                Navigator.of(context).push(DashboardView.route(
                  dbApi: ref.read(firebaseDBApiProvider),
                ));
              }
            },
            child: const Text('Ok'))
      ],
    ),
  );
}

/// Validates the given [value] and returns an error message if the value is empty.
/// This is being used to validate all the text fields in the app.
String? validator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

Future<dynamic> showDeleteDialog(
    {required BuildContext context,
    required SalonController salonController,
    required Widget confirmWidget,
    required Widget cancelWidget}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm Delete"),
      content: const Text("Are you sure you want to delete this salon?"),
      actions: [
        cancelWidget,
        confirmWidget,
      ],
    ),
  );
}
