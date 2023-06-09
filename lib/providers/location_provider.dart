import 'dart:async';
import 'package:betterroute/home/myhome.dart';
import 'package:betterroute/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? _position;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isListening = false;
  List<Map> _coordinatesList = [];
  Position? _previousPosition;
  Position? _currentPosition;
  double _totalDistance = 0.0;
  Duration _totalTime = Duration.zero;
  DateTime? _date;
  int _totalGriefs = 0;

  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> getLocationStream() async {
    // Check if permission is granted
    if (!await checkPermission()) {
      return;
    }

    // Check if location service is enabled
    if (!await isLocationServiceEnabled()) {
      // Location service is not enabled, prompt user to enable it
      final result = await Geolocator.openLocationSettings();
      if (!result) {
        // User did not enable location service
        return;
      }
    }
    if (_isListening) return;
    _isListening = true;
    _date = DateTime.now();
    _positionStreamSubscription = Geolocator.getPositionStream().listen(
      (position) {
        _position = position;
        _currentPosition = position;
        if (_previousPosition != null &&
            Geolocator.distanceBetween(
                    _previousPosition!.latitude,
                    _previousPosition!.longitude,
                    _currentPosition!.latitude,
                    _currentPosition!.longitude) >=
                10) {
          // Calculate the distance between the previous and current position
          final distance = Geolocator.distanceBetween(
              _previousPosition!.latitude,
              _previousPosition!.longitude,
              _currentPosition!.latitude,
              _currentPosition!.longitude);
          // Add the distance to the total distance
          _totalDistance += distance;

          // Calculate the time difference between the previous and current position
          final timeDifference = _currentPosition!.timestamp!
              .difference(_previousPosition!.timestamp!);
          // Add the time difference to the total time
          _totalTime += timeDifference;

          // Add the current position to the coordinates list
          _coordinatesList.add({
            'latitude': _currentPosition!.latitude,
            'longitude': _currentPosition!.longitude
          });

          // Update the previous position to the current position
          _previousPosition = _currentPosition;
        }
        notifyListeners();
      },
      onError: (error) {
        // Handle location updates error
      },
      cancelOnError: true,
    );
    // Get current location
    //_position = await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    if (!await checkPermission()) {
      return;
    }

    // Check if location service is enabled
    if (!await isLocationServiceEnabled()) {
      // Location service is not enabled, prompt user to enable it
      final result = await Geolocator.openLocationSettings();
      if (!result) {
        // User did not enable location service
        return;
      }
    }
    _position = await Geolocator.getCurrentPosition();
    _previousPosition = _position;
    _coordinatesList.add(
        {'latitude': _position!.latitude, 'longitude': _position!.longitude});
    notifyListeners();
  }

  Future<void> updateGriefCount() async {
    _totalGriefs += 1;
    notifyListeners();
  }

  Future<void> stopListening(
      String uid, String routeId, String routeMode) async {
    _position = await Geolocator.getCurrentPosition();
    final distance = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        _position!.latitude,
        _position!.longitude);
    _totalDistance += distance;
    final dist = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        _position!.latitude,
        _position!.longitude);
    _totalDistance += dist;
    final timeDiff =
        _position!.timestamp!.difference(_previousPosition!.timestamp!);
    _totalTime += timeDiff;
    _coordinatesList.add(
        {'latitude': _position!.latitude, 'longitude': _position!.longitude});
    final routeData = {
      'routeId': routeId,
      'routeCoordinates': _coordinatesList,
      'routeMode': routeMode,
      'createdAt': FieldValue.serverTimestamp(),
      'totalDist': _totalDistance,
      'totalTime': _totalTime.toString(),
      'totalGriefs': _totalGriefs
    };
    await FirebaseFirestore.instance
        .collection('userroutes')
        .doc(uid)
        .collection('routesList')
        .doc(routeId)
        .set(routeData);
    await FirestoreService().updateTripReport(_totalDistance);
    await FirestoreService().updateLastRouteAddedUser();
    await FirestoreService().updateLeaderboard(_totalDistance);
    if (!_isListening) return;
    _isListening = false;
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _coordinatesList = [];
    _totalDistance = 0.0;
    _totalTime = Duration.zero;
    _totalGriefs = 0;
    notifyListeners();
  }

  void emptyStopListening(BuildContext context) {
    if (!_isListening) return;
    _isListening = false;
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _coordinatesList = [];
    _totalDistance = 0.0;
    _totalTime = Duration.zero;
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => MyHomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
      (route) => false,
    );
    notifyListeners();
  }

  Position? get position => _position;
  bool get isListening => _isListening;
  List<Map> get coordinatesList => _coordinatesList;
  double get totalDistance => _totalDistance;
  Duration get totalTime => _totalTime;
  int get totalGriefs => _totalGriefs;
}
