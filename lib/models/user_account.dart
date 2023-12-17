import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  String? id;
  final String? name;
  final String? email;
  final String? photoUrl;

  UserAccount({
    this.id,
    this.name,
    required this.email,
    this.photoUrl,
  });

  factory UserAccount.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserAccount(
      id: snapshot.id,
      name: data?['name'],
      email: data?['email'],
      photoUrl: data?['photo_url'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photoUrl != null) "phto_url": photoUrl,
    };
  }

  void setId(String id) {
    this.id = id;
  }
}
