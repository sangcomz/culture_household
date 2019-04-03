import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culture_household/splash_page.dart';
import 'package:flutter/material.dart';

//void main() => runApp(MyApp());

Future<void> main() async {
  final Firestore firestore = Firestore.instance;
  await firestore.settings(
      persistenceEnabled: false, timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
