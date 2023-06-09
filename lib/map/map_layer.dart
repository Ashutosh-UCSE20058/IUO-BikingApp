import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapLayer extends StatefulWidget {
  final List<Map<String, double>> points;
  final List<Map<String, dynamic>> issues;
  const MapLayer({super.key, required this.points, required this.issues});

  @override
  State<MapLayer> createState() => _MapLayerState();
}

class _MapLayerState extends State<MapLayer> {
  @override
  Widget build(BuildContext context) {
    List<Marker> markers;
    List<LatLng> latlngPoints = widget.points
        .map((point) => LatLng(point['latitude']!, point['longitude']!))
        .toList();
    LatLng center = calculateCenterPoint(latlngPoints);
    if (widget.issues.isNotEmpty) {
      markers = widget.issues
          .map((issue) => Marker(
                width: 20,
                height: 20,
                point: LatLng(issue["latitude"]!, issue["longitude"]!),
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    _onTappedMarker(
                        context,
                        issue["issueList"]!,
                        issue["color"]!,
                        issue["type"]!,
                        issue["imageUrl"]!,
                        issue["comment"]!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: issue["color"] == "yellow"
                            ? Colors.yellow
                            : issue["color"] == "purple"
                                ? Colors.purple
                                : issue["color"] == "green"
                                    ? Colors.green
                                    : issue["color"] == "blue"
                                        ? Colors.blue
                                        : Colors.black),
                  ),
                ),
              ))
          .toList();
    } else {
      markers = [];
    }
    return Container(
      child: FlutterMap(
        options: MapOptions(
          center: center,
          zoom: 18.0,
        ),
        children: [
          TileLayer(
            tileSize: 256,
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            maxZoom: 100,
            maxNativeZoom: 100,
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
          MarkerLayer(
            markers: [
              Marker(
                  point: latlngPoints[0],
                  builder: (ctx) => Transform.translate(
                        offset: Offset(0, -10),
                        child: Icon(
                          FontAwesomeIcons.locationDot,
                          color: Colors.blue,
                        ),
                      )),
              Marker(
                  point: latlngPoints[latlngPoints.length - 1],
                  builder: (ctx) => Transform.translate(
                        offset: Offset(10, -10),
                        child: Icon(
                          FontAwesomeIcons.flagCheckered,
                          color: Colors.black,
                        ),
                      ))
            ],
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }

  LatLng calculateCenterPoint(List<LatLng> coordinates) {
    double totalLatitude = 0.0;
    double totalLongitude = 0.0;

    for (LatLng coordinate in coordinates) {
      totalLatitude += coordinate.latitude;
      totalLongitude += coordinate.longitude;
    }

    double avgLatitude = totalLatitude / coordinates.length;
    double avgLongitude = totalLongitude / coordinates.length;

    return LatLng(avgLatitude, avgLongitude);
  }
}

_onTappedMarker(BuildContext context, List<dynamic> issuesList, String color,
    String type, String imageUrl, String comment) {
  showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(children: [
              Container(
                height: 50.0,
                color: color == "yellow"
                    ? Colors.yellow
                    : color == "purple"
                        ? Colors.purple
                        : color == "green"
                            ? Colors.green
                            : color == "blue"
                                ? Colors.blue
                                : Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${type} Issue",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 48.0),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Issue Type:",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          type,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Highlighted Issues:",
                            style: TextStyle(fontSize: 14)),
                        SizedBox(
                          height: 5,
                        ),
                        issuesList.isNotEmpty
                            ? ToggleButtons(
                                children: issuesList
                                    .map((issue) => Text(issue))
                                    .toList(),
                                isSelected:
                                    issuesList.map((issue) => false).toList(),
                                onPressed: null,
                                borderRadius: BorderRadius.circular(2.0),
                                direction: Axis.vertical,
                                borderColor: Colors.grey,
                                disabledColor: Colors.black,
                                disabledBorderColor: Colors.grey,
                              )
                            : Text('None',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w600)),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Image: ", style: TextStyle(fontSize: 14)),
                        SizedBox(
                          height: 5,
                        ),
                        imageUrl != ""
                            ? Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.contain),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              )
                            : Text('None',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w600)),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Comment:", style: TextStyle(fontSize: 14)),
                        const SizedBox(
                          height: 5,
                        ),
                        comment != ""
                            ? Text(
                                comment,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            : Text('None',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w600)),
                      ]),
                ),
              ))
            ]));
      });
}
