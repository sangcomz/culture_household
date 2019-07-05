import 'package:culture_household/group_manager.dart';
import 'package:culture_household/group_page.dart';
import 'package:culture_household/login_page.dart';
import 'package:culture_household/main_page.dart';
import 'package:culture_household/views.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatelessWidget {
  _initState(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser != null)
        joinedGroup(firebaseUser.uid).then((group) {
          if (group != null)
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(firebaseUser, group)));
          else
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => GroupPage()));
        });
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
    }).catchError((onError) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });

  }

  @override
  Widget build(BuildContext context) {
    _initState(context);
    return Scaffold(
        body: Center(
      child: Container(
        child: bmjuaText('문화 가계부', 30, TextAlign.center),
      ),
    ));
  }

}
