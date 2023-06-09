import 'package:betterroute/grievances/grievances.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapDetails extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;
  final int totalGriefs;
  final DateTime createdAt;
  final String totalTime;
  final num totalDist;
  final String routeType;
  final List<Map<String, dynamic>> issues;
  const MapDetails(
      {super.key,
      required this.controller,
      required this.panelController,
      required this.totalGriefs,
      required this.createdAt,
      required this.totalTime,
      required this.totalDist,
      required this.routeType,
      required this.issues});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          height: 12,
        ),
        buildDragHandle(),
        SizedBox(height: 18),
        Center(
            child: Text(
          '''About This Trip''',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
        )),
        SizedBox(
          height: 18,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 2,
          decoration: BoxDecoration(color: Colors.grey[300]),
        ),
        SizedBox(height: 18),
        buildAboutText(context),
        SizedBox(
          height: 18,
        ),
      ],
    );
  }

  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(12)),
          ),
        ),
        onTap: togglePanel,
      );
  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();

  Widget buildAboutText(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Text("Mode: "),
                    SizedBox(height: 8),
                    Text(
                        "${routeType[0].toUpperCase()}${routeType.substring(1).toLowerCase()}",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 18,
                    ),
                    Text("Distance Covered: "),
                    SizedBox(
                      height: 8,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("${(totalDist / 1000).toStringAsFixed(2)}km",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Text("Trip Date: "),
                    SizedBox(
                      height: 8,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                          "${createdAt.day}/${createdAt.month}/${createdAt.year}",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text("Duration: "),
                    SizedBox(
                      height: 8,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(totalTime.split(".")[0],
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              )
            ]),
            SizedBox(
              height: 24,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Issues Reported: "),
                  SizedBox(
                    height: 8,
                  ),
                  Text("${totalGriefs}",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w600))
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Center(
                child: ElevatedButton(
              child: Text(
                "View All Issues",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: totalGriefs > 0
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              GrievanceScreen(issues: issues)));
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    totalGriefs > 0 ? Colors.orange : Colors.grey),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              ),
            ))
          ],
        ),
      );

  Widget buildAboutLegend() => Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Issues Legend: "),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Amenities"),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Infrastructure"),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Safety & Security"),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                      "${routeType[0].toUpperCase()}${routeType.substring(1).toLowerCase()}Experience"),
                ],
              )
            ],
          ),
        ),
      );
}
