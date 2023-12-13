import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymenntDetailsProvider = Provider((ref) {
  return PaymentDetailsProvider();
});

class PaymentDetailsProvider {
  late double bill;

  void setBill(double bill) {
    this.bill = bill;
  }
}
