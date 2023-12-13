import 'package:flutter_riverpod/flutter_riverpod.dart';

final driverDataProvider = Provider((ref) {
  return DriverDataProvider();
});

class DriverDataProvider {
  String? driverId;
}
