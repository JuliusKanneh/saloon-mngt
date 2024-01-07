import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  String? id;

  /// role can be either 'user' or 'admin'.
  /// It is used to determine the access level(authorization) of the user.
  String? role;

  final String? name;
  final String? email;
  final String? photoUrl;

  UserAccount({
    this.id,
    this.name,
    required this.email,
    this.photoUrl,
    this.role,
  });

  factory UserAccount.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserAccount(
      id: snapshot.id,
      name: data?['name'],
      email: data?['email'],
      photoUrl: data?['photo_url'],
      role: data?['role'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photoUrl != null) "phto_url": photoUrl,
      if (role != null) "role": role,
    };
  }

  void setId(String id) {
    this.id = id;
  }

  /// set the role of the user. It can be either 'user' or 'admin'.
  void setRole(String role) {
    this.role = role;
  }
}
