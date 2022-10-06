import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'utils/globals.dart' as globals;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load(fileName: ".env");
  globals.appNavigator = GlobalKey<NavigatorState>();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const App());

}


// Not use this method
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}