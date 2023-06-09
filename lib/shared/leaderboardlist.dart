import 'package:betterroute/services/services.dart';
import 'package:flutter/material.dart';

class LeaderBoardList extends StatelessWidget {
  const LeaderBoardList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: FirestoreService().getLeaderboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            return DataTable(
              columns: [
                DataColumn(label: Text('Rank')),
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text('Distance Covered'),
                  numeric: true,
                ),
              ],
              rows: data!
                  .map((row) => DataRow(
                        cells: [
                          DataCell(Text((data.indexOf(row) + 1).toString())),
                          DataCell(Text(row['name'] ?? '')),
                          DataCell(Text(
                              '${(row['distanceCovered'] / 1000).toStringAsFixed(2) ?? ''}')),
                        ],
                      ))
                  .toList(),
            );
          } else {
            return const Text('No data found');
          }
        });
  }
}
