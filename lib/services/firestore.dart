import 'package:betterroute/services/auth.dart';
import 'package:betterroute/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var user = AuthService().user!;

  Future<List<Route>> getRoutes() async {
    var ref = _db
        .collection('userroutes')
        .doc(user.uid)
        .collection('routesList')
        .orderBy('createdAt', descending: true);
    ;
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var routes = data.map<Route>((d) => Route.fromJson(d)).toList();
    return routes.toList();
  }

  Future<Questionnaire> getQuestionnaire(String modeType) async {
    var ref = _db.collection('questionnaire').doc(modeType);
    var snapshot = await ref.get();
    return Questionnaire.fromJson(snapshot.data() ?? {});
  }

  Future<List<Grievance>> getGrievances(String routeId) async {
    var ref = _db.collection('grievances').doc(routeId).collection('griefs');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var griefs = data.map((d) => Grievance.fromJson(d)).toList();
    return griefs.reversed.toList();
  }

  Stream<Report> streamReport() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Report()]);
      }
    });
  }

  Future<void> updateGrievanceReport() async {
    var ref = _db.collection('reports').doc(user.uid);
    var data = {
      'totalGrievances': FieldValue.increment(1),
    };
    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateTripReport(double totalDistance) async {
    var ref = _db.collection('reports').doc(user.uid);
    var data = {
      'trips': FieldValue.increment(1),
      'totalDistance': FieldValue.increment(totalDistance),
    };
    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateLeaderboard(double totalDistance) async {
    var ref = _db.collection('keaderboard').doc(user.uid);
    var data = {
      'totalDistance': FieldValue.increment(totalDistance),
    };
    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateLastRouteAddedUser() async {
    var ref = _db.collection('users').doc(user.uid);
    var data = {
      'updatedAt': FieldValue.serverTimestamp(),
      'lastRouteAddedAt': FieldValue.serverTimestamp()
    };
    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateLastGrievanceAddedUser() async {
    var ref = _db.collection('users').doc(user.uid);
    var data = {
      'updatedAt': FieldValue.serverTimestamp(),
      'lastGrievanceAddedAt': FieldValue.serverTimestamp()
    };
    return ref.set(data, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getLeaderboardData() async {
    // get all users
    final usersQuerySnapshot = await FirebaseFirestore.instance
        .collection('leaderboard')
        .orderBy('totalDistance', descending: true)
        .get();

    // list to hold leaderboard data
    List<Map<String, dynamic>> leaderboardData = [];

    // loop through users to get their name and distance covered
    for (final userDoc in usersQuerySnapshot.docs) {
      final name = userDoc.get('displayName');
      final email = userDoc.get('email');
      final totalDistanceCovered = userDoc.get('totalDistance');

      leaderboardData.add({
        'name': name,
        'distanceCovered': totalDistanceCovered,
        'email': email
      });
    }

    return leaderboardData;
  }

  Future<List<Map<String, dynamic>>> getTodayLeaderboardData() async {
    // Construct the start and end timestamps for today
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay = startOfDay.add(Duration(days: 1));

    final Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    final Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    //get all users
    final usersQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('lastRouteAddedAt',
            isGreaterThanOrEqualTo: startTimestamp, isLessThan: endTimestamp)
        .get();

    if (usersQuerySnapshot.docs.isEmpty) {
      return [];
    }
    // list to hold leaderboard data
    List<Map<String, dynamic>> leaderboardData = [];

    // loop through users to get their name and distance covered
    for (final userDoc in usersQuerySnapshot.docs) {
      final name = userDoc.get('displayName');
      final userId = userDoc.get('uid');
      final email = userDoc.get('email');
      // get the user's route list
      var totalDistanceCovered = 0.0;
      final routesSnapshot = await FirebaseFirestore.instance
          .collection('userroutes')
          .doc(userId)
          .collection('routesList')
          .where('createdAt',
              isGreaterThanOrEqualTo: startTimestamp, isLessThan: endTimestamp)
          .get();

      routesSnapshot.docs.forEach((route) {
        totalDistanceCovered += route.get('totalDist');
      });

      leaderboardData.add({
        'name': name,
        'distanceCovered': totalDistanceCovered,
        'email': email
      });
    }

    // sort the leaderboard data in descending order
    leaderboardData
        .sort((a, b) => (b['distanceCovered']).compareTo(a['distanceCovered']));

    return leaderboardData;
  }

  Future<List<Map<String, dynamic>>> getIssuesData(
      num totalGriefs, String routeId) async {
    if (totalGriefs == 0) {
      return Future.value([]);
    } else {
      final issueQuerySnapshot = await FirebaseFirestore.instance
          .collection('grievances')
          .doc(routeId)
          .collection('griefs')
          .get();
      List<Map<String, dynamic>> issues = [];
      for (final issueDoc in issueQuerySnapshot.docs) {
        final color = issueDoc.get("issueColor");
        final latitude = issueDoc.get("location")["latitude"];
        final longitude = issueDoc.get("location")["longitude"];
        final comment = issueDoc.get("comment");
        final issueList = issueDoc.get("issueList");
        final type = issueDoc.get("type");
        final imageUrl = issueDoc.get("imageUrl");
        issues.add({
          'type': type,
          'comment': comment,
          'latitude': latitude,
          'longitude': longitude,
          'issueList': issueList,
          'imageUrl': imageUrl,
          'color': color
        });
      }
      return issues;
    }
  }
}
