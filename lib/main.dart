import 'package:betterroute/providers/location_provider.dart';
import 'package:betterroute/routes.dart';
import 'package:betterroute/services/firestore.dart';
import 'package:betterroute/services/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the firebase_core pluginflu
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          /*return MaterialApp(
            routes: appRoutes,
          );*/
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<LocationProvider>(
                create: (_) => LocationProvider(),
              ),
              StreamProvider<Report>(
                  create: (_) => FirestoreService().streamReport(),
                  catchError: (_, err) => Report(),
                  initialData: Report())
            ],
            child: MaterialApp(routes: appRoutes),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        );
      },
    );
  }
}
