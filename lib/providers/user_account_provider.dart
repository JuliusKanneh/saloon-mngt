import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saloon/models/user_account.dart';

final userAccountProvider = Provider((ref) {
  return UserAccountProvider();
});

class UserAccountProvider {
  UserAccount? user;

  void setUser(UserAccount user) {
    this.user = user;
  }

  UserAccount? getUser() => user;
}
