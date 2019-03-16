import 'dart:async';

import 'package:culture_household/main_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  _timerState(BuildContext context) {
    new Timer(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    _timerState(context);
    return Scaffold(
        body: Center(
      child: Container(
        child: Text('문화 가계부',
            style: TextStyle(fontSize: 30, fontFamily: "Roboto")),
      ),
    ));
  }
}
