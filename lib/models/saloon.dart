import 'package:cloud_firestore/cloud_firestore.dart';

class Salon {
  final String? id;
  final String? name;
  final String? address;
  final String? contact;
  final String? managerName;
  final String? photoUrl;
  final bool? isFavorite;

  Salon({
    this.id,
    this.address,
    this.name,
    this.contact,
    this.managerName,
    this.photoUrl,
    this.isFavorite = false,
  });

  factory Salon.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();

    return Salon(
      id: snapshot.id,
      address: data?['address'],
      photoUrl: data?['photo_url'],
      managerName: data?['manager_name'],
      name: data?['name'],
      contact: data?['contact'],
      isFavorite: data?['is_favorite'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (address != null) "address": address,
      if (photoUrl != null) "photo_url": photoUrl,
      if (managerName != null) "manager_name": managerName,
      if (contact != null) "contact": contact,
      if (isFavorite != null) "is_favorite": isFavorite,
    };
  }

  /// This is used to update the document with the given id
  Map<String, dynamic> toFirestoreWithId() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (address != null) "address": address,
      if (photoUrl != null) "photo_url": photoUrl,
      if (managerName != null) "manager_name": managerName,
      if (contact != null) "contact": contact,
      if (isFavorite != null) "is_favorite": isFavorite,
    };
  }
}
