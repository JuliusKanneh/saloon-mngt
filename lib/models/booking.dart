import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Booking {
  String? id;
  String? userId;
  String? saloonId;
  String? gender;
  String? style;
  DateTime? date;
  TimeOfDay? time;
  String? status;
  String? stylist;

  Booking({
    this.id,
    this.userId,
    this.saloonId,
    this.gender,
    this.style,
    this.date,
    this.time,
    this.status,
    this.stylist,
  });

  factory Booking.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();

    return Booking(
      id: snapshot.id,
      date: DateTime.parse(data?['date']),
      time: TimeOfDay(
        hour: int.parse(data!['time'].toString().substring(10, 12)),
        minute: int.parse(data['time'].toString().substring(13, 15)),
      ),
      gender: data['gender'],
      style: data['style'],
      userId: data['user_id'],
      saloonId: data['saloon_id'],
      status: data['status'],
      stylist: data['stylist'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (date != null) 'date': date.toString().split(' ')[0],
      if (time != null) 'time': time.toString().split(' ')[0],
      if (userId != null) 'user_id': userId,
      if (saloonId != null) 'saloon_id': saloonId,
      if (gender != null) 'gender': gender,
      if (style != null) 'style': style,
      if (status != null) 'status': status,
      if (stylist != null) 'stylist': stylist,
    };
  }
}
