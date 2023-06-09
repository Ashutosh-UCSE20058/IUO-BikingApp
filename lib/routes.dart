import "package:betterroute/cycle/cycle.dart";
import "package:betterroute/home/myhome.dart";
import "package:betterroute/leaderboard/leaderboard.dart";
import "package:betterroute/trips/trips.dart";
import "package:betterroute/walk/walk.dart";
import "package:betterroute/login/login.dart";
import "package:betterroute/start/start.dart";

var appRoutes = {
  '/': (context) => const StartScreen(),
  '/home': (context) => const MyHomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/walk': (context) => const WalkScreen(),
  '/cycle': (context) => const CycleScreen(),
  '/trips': (context) => const TripScreen(),
  '/leaderboard': (context) => const LeaderBoardScreen()
};
