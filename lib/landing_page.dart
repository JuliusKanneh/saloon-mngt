import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  late DatabaseReference _dbref;
  var databasejson;
  var totalSalon;

  // _readDB_oncechild() {
  //   _dbref.child("salons").child("total").once().then((value) {
  //     log('read once - ${value.snapshot.value}');
  //     setState(() {
  //       totalSalon = value.snapshot.value;
  //     });
  //   });
  // }

  _readDBRealtime() {
    _dbref.child("salons").child("total").onValue.listen((event) {
      setState(() {
        totalSalon = event.snapshot.value;
      });
      log('realtime: $totalSalon'); //this still holds the previous state.
    });
  }

  _readDBRealtimeCollection() {
    _dbref.child("lot_occupancy").onValue.listen((event) {
      setState(() {
        databasejson = event.snapshot.value;
      });
      log('realtime: $databasejson'); //this still holds the previous state.
    });
  }

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
    // _readDB_oncechild();
    _readDBRealtime();
    _readDBRealtimeCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        //consider using stream builder
        children: [
          Text('Total Saloon: $totalSalon'),
          Text('databasejson: $databasejson'),
          Divider(),
          Text(
              'databasejson: ${databasejson['AKlGUj8dCliyZQGnpW34']['availableSlotCount']}'),
        ],
      )),
    );
  }
}
