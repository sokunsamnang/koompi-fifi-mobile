import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'utils/globals.dart' as globals;
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  globals.appNavigator = GlobalKey<NavigatorState>();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://d377e234335e4d2ca9e4f88cfc7e2ca4@o1184519.ingest.sentry.io/6302742';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () =>   runApp(const App()),
  );



}
