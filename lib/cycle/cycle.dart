import 'dart:convert';
import 'dart:io';
import 'package:betterroute/classes/screenArgs.dart';
import 'package:betterroute/home/myhome.dart';
import 'package:betterroute/providers/location_provider.dart';
import 'package:betterroute/services/auth.dart';
import 'package:betterroute/services/firestore.dart';
import 'package:betterroute/shared/issue_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CycleScreen extends StatefulWidget {
  const CycleScreen({super.key});

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  bool _isSubmitting = false;
  bool _confirm = false;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).getLocationStream();
  }

  Future<bool> _onWillPop() async {
    if (_isSubmitting) {
      return false; // prevent back navigation while loading
    } else {
      _confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Stop Trip'),
            content: Text('Press the Stop icon button to stop the trip'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _confirm = true;
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );

      return _confirm;
    }
  }

  showUnsuccessfulDialog(String errorString) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(errorString),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArgs;
    var user = AuthService().user!;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.amber.shade800,
              body: SafeArea(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(children: [
                      Expanded(
                          child: Container(
                        height: 240,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Distance Covered (km)',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ]),
                              ),
                              Consumer<LocationProvider>(
                                  builder: (context, locationProvider, _) {
                                return Text(
                                  (locationProvider.totalDistance / 1000)
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 106,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ]),
                                );
                              }),
                              ElevatedButton(
                                child: Text(
                                  "Stop Trip",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.white),
                                    shape: MaterialStatePropertyAll<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)))),
                                onPressed: () async {
                                  if (Provider.of<LocationProvider>(context,
                                              listen: false)
                                          .totalDistance <=
                                      10) {
                                    showDialog(
                                        context: context,
                                        builder: ((context) => AlertDialog(
                                              title: Text("Confirmation"),
                                              content: Text(
                                                  "You haven't covered enough distance for this session to be considered a trip. End trip?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () => Provider
                                                            .of<LocationProvider>(
                                                                context,
                                                                listen: false)
                                                        .emptyStopListening(
                                                            context),
                                                    child: Text("Yes")),
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("No")),
                                              ],
                                            )));
                                  } else {
                                    setState(() {
                                      _isSubmitting = true;
                                    });
                                    try {
                                      await Provider.of<LocationProvider>(
                                              context,
                                              listen: false)
                                          .stopListening(user.uid, args.routeId,
                                              'cycling');
                                      setState(() {
                                        _isSubmitting = false;
                                      });
                                      if (mounted) {
                                        Navigator.pop(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                            pageBuilder: (_, __, ___) =>
                                                MyHomeScreen(),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                              return SlideTransition(
                                                position: Tween(
                                                  begin: Offset(-1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      setState(() {
                                        _isSubmitting = false;
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text('Error'),
                                                content: Text(
                                                    'An error occurred while uploading the route. $e'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              '/home',
                                                              (route) => false);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ))
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          children: [
                            Row(children: [
                              Text(
                                "Select Issue:",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black87),
                              )
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future: DefaultAssetBundle.of(context)
                                  .loadString("asset/questionnare.json"),
                              builder: (context, snapshot) {
                                var mydata =
                                    json.decode(snapshot.data.toString());
                                if (mydata == null) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 1.0,
                                      mainAxisSpacing: 1.0,
                                      childAspectRatio: 0.9,
                                      children: mydata["cycling"]
                                              ["grievanceTypes"]
                                          .map<Widget>((item) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(milliseconds: 500),
                                              pageBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {
                                                return IssueForm(
                                                    issueList: item["subtypes"],
                                                    issueType: item["name"],
                                                    issueColor:
                                                        item["grievanceColor"],
                                                    routeId: args.routeId);
                                              },
                                              transitionsBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation,
                                                  Widget child) {
                                                return SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin:
                                                        const Offset(0.0, 1.0),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: child,
                                                );
                                              },
                                            ));
                                          },
                                          child: Card(
                                            elevation:
                                                2, // Add elevation to the card
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // Add rounded borders
                                            ),
                                            child: Container(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GetIcon(
                                                        iconData: item["name"]),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      item["name"],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
                ],
              )),
            ),
            if (_isSubmitting)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (_isSubmitting)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
          ],
        ));
  }
}

class GetIcon extends StatelessWidget {
  final String iconData;
  const GetIcon({super.key, required this.iconData});

  @override
  Widget build(BuildContext context) {
    if (iconData == "Amenities") {
      return Icon(
        FontAwesomeIcons.restroom,
        size: 32,
        color: Colors.black.withOpacity(0.5),
      );
    } else if (iconData == "Infrastructure") {
      return Icon(FontAwesomeIcons.buildingCircleXmark,
          size: 32, color: Colors.black.withOpacity(0.5));
    } else if (iconData == "Safety & Security") {
      return Icon(FontAwesomeIcons.shield,
          size: 32, color: Colors.black.withOpacity(0.5));
    } else if (iconData == "Walking Experience") {
      return Icon(FontAwesomeIcons.shoePrints,
          size: 32, color: Colors.black.withOpacity(0.5));
    } else if (iconData == "Cycling Experience") {
      return Icon(FontAwesomeIcons.bicycle,
          size: 32, color: Colors.black.withOpacity(0.5));
    } else {
      return const CircularProgressIndicator();
    }
  }
}
