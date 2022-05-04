import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'utils/globals.dart' as globals;

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


Future<void> main() async {
  globals.appNavigator = GlobalKey<NavigatorState>();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // HttpOverrides.global = MyHttpOverrides();

  runApp(const App());



}
