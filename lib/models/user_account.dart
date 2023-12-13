class UserAccount {
  String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? photo;
  final String? plateNumber;

  UserAccount({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.photo,
    this.plateNumber,
  });

  // factory UserAccount.fromFirestore(
  //     DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   final data = snapshot.data();
  //   return UserAccount(
  //     id: snapshot.id,
  //     firstName: data?['firstname'],
  //     lastName: data?['lastname'],
  //     email: data?['email'],
  //     phoneNumber: data?['phone_number'],
  //     photo: data?['photo'],
  //     plateNumber: data?['plate_number'],
  //   );
  // }

  Map<String, dynamic> toFireStore() {
    return {
      if (firstName != null) "firstname": firstName,
      if (lastName != null) "lastname": lastName,
      if (email != null) "email": email,
      if (phoneNumber != null) "phone_number": phoneNumber,
      if (photo != null) "photo": photo,
      if (plateNumber != null) "plate_number": plateNumber,
    };
  }

  void setId(String id) {
    this.id = id;
  }
}
