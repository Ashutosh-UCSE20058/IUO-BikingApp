import 'package:betterroute/services/firestore.dart';
import 'package:betterroute/shared/error.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class GrievanceScreen extends StatefulWidget {
  final List<Map<String, dynamic>> issues;
  const GrievanceScreen({super.key, required this.issues});

  @override
  State<GrievanceScreen> createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends State<GrievanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Issues"),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ListView(
          children: [
            Column(
              children: widget.issues.mapIndexed((i, issue) {
                return Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            issue["imageUrl"] != ""
                                ? Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      color: Colors.black.withOpacity(0.8),
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(issue["imageUrl"]),
                                          fit: BoxFit.contain),
                                    ),
                                  )
                                : Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      color: const Color(0xff7c94b6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No Image",
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                    ),
                                  ),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10)),
                                color: issue["color"] == "yellow"
                                    ? Colors.yellow
                                    : issue["color"] == "purple"
                                        ? Colors.purple
                                        : issue["color"] == "green"
                                            ? Colors.green
                                            : issue["color"] == "blue"
                                                ? Colors.blue
                                                : Colors.black,
                              ),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${issue["type"]} Issue",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              scrollable: true,
                                              title: Text(
                                                'Details',
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              ),
                                              content: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Issue Type:",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(issue["type"],
                                                        style: TextStyle(
                                                            fontSize: 32,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                        "Highlighted Issues:",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    issue["issueList"]
                                                            .isNotEmpty
                                                        ? ToggleButtons(
                                                            children:
                                                                (issue["issueList"]
                                                                        as List)
                                                                    .map((e) =>
                                                                        Text(e))
                                                                    .toList(),
                                                            isSelected:
                                                                (issue["issueList"]
                                                                        as List)
                                                                    .map((e) =>
                                                                        false)
                                                                    .toList(),
                                                            onPressed: null,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.0),
                                                            direction:
                                                                Axis.vertical,
                                                            borderColor:
                                                                Colors.grey,
                                                            disabledColor:
                                                                Colors.black,
                                                            disabledBorderColor:
                                                                Colors.grey,
                                                          )
                                                        : Text('None',
                                                            style: TextStyle(
                                                                fontSize: 32,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text("Comment:",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    issue["comment"] != ""
                                                        ? Text(
                                                            issue["comment"],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )
                                                        : Text('None',
                                                            style: TextStyle(
                                                                fontSize: 32,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text("View Details",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.orange),
                                        shape: MaterialStatePropertyAll<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)))),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    ));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
