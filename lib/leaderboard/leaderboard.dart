import 'package:betterroute/leaderboard/leaderboard_all_time.dart';
import 'package:betterroute/leaderboard/leaderboard_daily.dart';
import 'package:betterroute/shared/leaderboardlist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  String dropdownValue = 'Today';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade800,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      iconSize: 24,
                    ),
                  ],
                ),
                SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Leaderboard",
                        style: TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(2, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(25),
                        underline: Container(),
                        icon: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>[
                          'All Time',
                          'Today',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey[200],
              child: Center(
                  child: Column(
                children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: ListTile(
                      leading: SizedBox(
                        height: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 19, 0, 0),
                          child: Text("User"),
                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Distance Covered(Km)",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(fit: BoxFit.scaleDown, child: Text("Rank"))
                        ],
                      ),
                    ),
                  ),
                  if (dropdownValue == "All Time")
                    Expanded(child: LeaderBoardAllTime()),
                  if (dropdownValue == "Today")
                    Expanded(
                      child: LeaderBoardDaily(),
                    )
                ],
              )),
            ),
          ))
        ],
      )),
    );
  }
}
