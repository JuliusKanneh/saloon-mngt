import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Salon {
  final String? id;
  final String? name;
  final String? address;
  final String? contact;
  final String? managerId;
  final String? photoUrl;
  final bool? isFavorite;
  final List<String>? maleStylists;
  final List<String>? femaleStylists;

  Salon({
    this.id,
    this.address,
    this.name,
    this.contact,
    this.managerId,
    this.photoUrl,
    this.isFavorite = false,
    this.maleStylists,
    this.femaleStylists,
  });

  factory Salon.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();

    return Salon(
      id: snapshot.id,
      address: data?['address'],
      photoUrl: data?['photo_url'],
      managerId: data?['manager_id'],
      name: data?['name'],
      contact: data?['contact'],
      isFavorite: data?['is_favorite'],
      maleStylists: List<String>.from(data?['male_stylists'] ?? []),
      femaleStylists: List<String>.from(data?['female_stylists'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (address != null) "address": address,
      if (photoUrl != null) "photo_url": photoUrl,
      if (managerId != null) "manager_id": managerId,
      if (contact != null) "contact": contact,
      if (isFavorite != null) "is_favorite": isFavorite,
      if (maleStylists != null) "male_stylists": jsonEncode(maleStylists),
      if (femaleStylists != null) "female_stylists": jsonEncode(femaleStylists),
    };
  }

  /// This is used to update the document with the given id
  Map<String, dynamic> toFirestoreWithId() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (address != null) "address": address,
      if (photoUrl != null) "photo_url": photoUrl,
      if (managerId != null) "manager_id": managerId,
      if (contact != null) "contact": contact,
      if (isFavorite != null) "is_favorite": isFavorite,
      if (maleStylists != null) "male_stylists": jsonEncode(maleStylists),
      if (femaleStylists != null) "female_stylists": jsonEncode(femaleStylists),
    };
  }
}
