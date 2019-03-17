import 'dart:async';

import 'package:culture_household/login_page.dart';
import 'package:culture_household/main_page.dart';
import 'package:culture_household/views.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatelessWidget {
  _timerState(BuildContext context) {
    new Timer(const Duration(milliseconds: 2000), () {
      FirebaseAuth.instance.currentUser().then((firebaseUser) {
        if (firebaseUser != null)
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        else
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
      }).catchError((onError) {
        debugPrint(onError.runtimeType.toString());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _timerState(context);
    return Scaffold(
        body: Center(
      child: Container(
        child: bmjuaText('문화 가계부', 30, TextAlign.center),
      ),
    ));
  }
}
