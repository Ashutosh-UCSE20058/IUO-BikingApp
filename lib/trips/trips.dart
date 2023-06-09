import 'package:betterroute/trips/trips_body.dart';
import 'package:flutter/material.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("All Trips"), backgroundColor: Colors.orange),
        backgroundColor: Colors.grey[200],
        body: TripsBodyScreen());
  }
}
