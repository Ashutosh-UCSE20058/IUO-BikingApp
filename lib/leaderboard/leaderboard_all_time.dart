import 'package:betterroute/services/firestore.dart';
import 'package:betterroute/shared/error.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderBoardAllTime extends StatelessWidget {
  const LeaderBoardAllTime({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreService().getLeaderboardData(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          } else if (snapshot.hasData) {
            var entries = snapshot.data!;
            return ListView(
              children: [
                Column(
                  children: entries.mapIndexed((index, entry) {
                    return Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: ListTile(
                            title: Container(
                              width: 120,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 160,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            entry["name"],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(entry["email"],
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text((entry["distanceCovered"] / 1000)
                                          .toStringAsFixed(2)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            trailing: Container(
                                alignment: Alignment.centerRight,
                                width: 40,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: (index + 1) == 1
                                      ? Icon(
                                          FontAwesomeIcons.medal,
                                          color: Colors.amber,
                                        )
                                      : (index + 1) == 2
                                          ? Icon(
                                              FontAwesomeIcons.medal,
                                              color: Colors.grey,
                                            )
                                          : (index + 1) == 3
                                              ? Icon(FontAwesomeIcons.medal,
                                                  color: Colors.brown.shade800)
                                              : Text(
                                                  (index + 1).toString(),
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                ))));
                  }).toList(),
                )
              ],
            );
          } else {
            return Center(child: Text('No Entries Found'));
          }
        }));
  }
}
