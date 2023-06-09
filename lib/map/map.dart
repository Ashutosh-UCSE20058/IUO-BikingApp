import 'package:betterroute/map/map_details.dart';
import 'package:betterroute/map/map_layer.dart';
import 'package:betterroute/services/firestore.dart';
import 'package:betterroute/shared/error.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, double>> points;
  final int totalGriefs;
  final String routeId;
  final DateTime createdAt;
  final String totalTime;
  final num totalDist;
  final String routeType;
  const MapScreen(
      {super.key,
      required this.points,
      required this.totalGriefs,
      required this.routeId,
      required this.createdAt,
      required this.totalDist,
      required this.totalTime,
      required this.routeType});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final panelController = PanelController();
  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    final panelHeightOpen = 420.0;
    return FutureBuilder(
        future: FirestoreService()
            .getIssuesData(widget.totalGriefs, widget.routeId),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ));
          } else if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          } else if (snapshot.hasData) {
            var issues = snapshot.data!;
            return Scaffold(
              body: SlidingUpPanel(
                controller: panelController,
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                minHeight: panelHeightClosed,
                maxHeight: panelHeightOpen,
                body: MapLayer(points: widget.points, issues: issues),
                panelBuilder: (controller) => MapDetails(
                    controller: controller,
                    panelController: panelController,
                    totalGriefs: widget.totalGriefs,
                    createdAt: widget.createdAt,
                    totalTime: widget.totalTime,
                    totalDist: widget.totalDist,
                    routeType: widget.routeType,
                    issues: issues),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: const Text("Nothing Found"),
              ),
            );
          }
        }));
    /*List<LatLng> latlngPoints = widget.points
        .map((point) => LatLng(point['latitude']!, point['longitude']!))
        .toList();
    LatLng center = calculateCenterPoint(latlngPoints);
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 7,
          child: FlutterMap(
            options: MapOptions(
              center: center,
              zoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: latlngPoints,
                    color: Colors.red,
                    strokeWidth: 4,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: ElevatedButton(
              onPressed: widget.totalGriefs > 0
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              GrievanceScreen(routeId: widget.routeId)));
                    }
                  : null,
              child: const Text("View Grievances"),
            ),
          ),
        )
      ],
    ));*/
  }
}
