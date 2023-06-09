import 'package:betterroute/map/map.dart';
import 'package:betterroute/services/firestore.dart';
import 'package:betterroute/shared/error.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TripsBodyScreen extends StatelessWidget {
  const TripsBodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getRoutes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorMessage(message: snapshot.error.toString());
        } else if (snapshot.hasData) {
          var routes = snapshot.data!;
          return Container(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: ListView(
              children: [
                Column(
                    children: routes.map((route) {
                  return Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => MapScreen(
                                      points: route.routeCoordinates,
                                      totalGriefs: route.totalGriefs,
                                      routeId: route.routeId,
                                      createdAt: route.createdAt,
                                      totalTime: route.totalTime,
                                      totalDist: route.totalDist,
                                      routeType: route.routeMode,
                                    )));
                          },
                          child: ListTile(
                            leading: Icon(
                              route.routeMode == "cycling"
                                  ? FontAwesomeIcons.bicycle
                                  : FontAwesomeIcons.personWalking,
                              size: 32,
                            ),
                            title: Row(
                              children: [
                                SizedBox(width: 8.0),
                                Text(
                                    '${(route.totalDist / 1000).toStringAsFixed(2)}km')
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                SizedBox(width: 8.0),
                                Text(route.totalTime.split(".")[0]),
                                SizedBox(width: 8.0),
                                Text(
                                    "${route.createdAt.day}/${route.createdAt.month}/${route.createdAt.year}")
                                //Text(route.startDate.substring(0, 10))
                              ],
                            ),
                            trailing: Icon(FontAwesomeIcons.play),
                          )));
                }).toList())
              ],
            ),
          );
        } else {
          return const Text('No trips found');
        }
      },
    );
  }
}
