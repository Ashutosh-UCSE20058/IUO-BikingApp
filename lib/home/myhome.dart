import 'package:betterroute/classes/screenArgs.dart';
import 'package:betterroute/leaderboard/leaderboard.dart';
import 'package:betterroute/services/auth.dart';
import 'package:betterroute/services/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:betterroute/walk/walk.dart';
import 'package:betterroute/cycle/cycle.dart';
import 'package:uuid/uuid.dart';
import 'package:betterroute/providers/location_provider.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);
    var user = AuthService().user!;
    final locationProvider = Provider.of<LocationProvider>(context);

    if (user!= null) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /*Icon(
                            FontAwesomeIcons.circleUser,
                            color: Colors.black,
                            size: 28,
                          )*/
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(user.photoURL ??
                                    'https://www.gravatar.com/avatar/placeholder'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  user.displayName ?? user.email!.split("@")[0],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  user.email ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.rightFromBracket,
                                size: 24,
                              ),
                              onPressed: () async {
                                await AuthService().signOut();
                                if (mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/', (route) => false);
                                }
                              },
                              color: Colors.black,
                              padding: EdgeInsets.zero,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => {
                    if (report.trips != 0)
                      {Navigator.pushNamed(context, '/trips')}
                    else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                "You don't have any trips!",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              behavior: SnackBarBehavior.floating,
                              width: MediaQuery.of(context).size.width - 20,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              duration: Duration(seconds: 2)),
                        )
                      }
                  },
                  splashColor: Colors.white.withOpacity(1),
                  splashFactory: InkRipple.splashFactory,
                  child: Container(
                      height: 180,
                      width: 340,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade800,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 0 * 3.14 / 180,
                                      child: Icon(FontAwesomeIcons.flag,
                                          color: Colors.white, size: 24),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text('${report.trips}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 42,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text('Trips',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 2,
                                  height: 140,
                                  color: Colors.white.withOpacity(.5)),
                              Expanded(
                                  flex: 6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.rotate(
                                        angle: 0 * 3.14 / 180,
                                        child: Icon(FontAwesomeIcons.route,
                                            color: Colors.white, size: 24),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                            '${(report.totalDistance / 1000).toStringAsFixed(2)}',
                                            style: GoogleFonts.roboto(
                                                fontSize: 42,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text('Distance Covered',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.white)),
                                      Text('(in Km)',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.white)),
                                    ],
                                  )),
                            ],
                          )
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 3 - 112,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal:
                            (MediaQuery.of(context).size.width - 336) / 2),
                    children: [
                      InkWell(
                          onTap: () async {
                            await locationProvider.getCurrentLocation();
                            if (locationProvider.position != null) {
                              String routeID = Uuid().v4();
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  pageBuilder: (_, __, ___) => WalkScreen(),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  settings: RouteSettings(
                                    arguments: ScreenArgs(routeID, 'walking'),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                  height: 140,
                                  width: 340,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          "Walking",
                                          style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber.shade800),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Icon(FontAwesomeIcons.arrowRight)
                                      ],
                                    ),
                                  )),
                              Positioned(
                                right: 24.0,
                                bottom: 10.0,
                                child: Icon(FontAwesomeIcons.personWalking,
                                    size: 120,
                                    color: Colors.black.withOpacity(0.25)),
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                          onTap: () async {
                            await locationProvider.getCurrentLocation();
                            if (locationProvider.position != null) {
                              String routeID = Uuid().v4();
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  pageBuilder: (_, __, ___) => CycleScreen(),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  settings: RouteSettings(
                                    arguments: ScreenArgs(routeID, 'cycling'),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                  height: 140,
                                  width: 340,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          "Cycling",
                                          style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber.shade800),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.arrowRight,
                                        )
                                      ],
                                    ),
                                  )),
                              Positioned(
                                right: 42.0,
                                bottom: 4.0,
                                child: Icon(FontAwesomeIcons.bicycle,
                                    size: 120,
                                    color: Colors.black.withOpacity(0.25)),
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) =>
                                    LeaderBoardScreen(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    )),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                  height: 140,
                                  width: 340,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "View",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          "Leaderboard",
                                          style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber.shade800),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.arrowRight,
                                        )
                                      ],
                                    ),
                                  )),
                              Positioned(
                                right: 42.0,
                                bottom: 4.0,
                                child: Icon(FontAwesomeIcons.rankingStar,
                                    size: 120,
                                    color: Colors.black.withOpacity(0.25)),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Text(
                "Powered by Smart Cities Mission | IUO",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          ],
        )),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }
  }
}
