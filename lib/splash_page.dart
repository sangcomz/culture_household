import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        joinedGroup(firebaseUser.uid).then((isJoined) {
          if (isJoined)
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          else
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => GroupPage()));
        });
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
    }).catchError((onError) {
      debugPrint('onError :::: ${onError.runtimeType.toString()}');
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

//  @override
//  Widget build(BuildContext context) {
//    _initState(context);
//    return Scaffold(body: Center(child: list()));
//  }

//  Widget list() {
//    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('group').snapshots(),
//      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if (!snapshot.hasData) return const Text('Loading...');
//        final int messageCount = snapshot.data.documents.length;
//        return ListView.builder(
//          itemCount: messageCount,
//          itemBuilder: (_, int index) {
//            final DocumentSnapshot document = snapshot.data.documents[index];
//            return ListTile(
//              title: Text(document['init'] ?? '<No message retrieved>'),
//              subtitle: Text('Message ${index + 1} of $messageCount'),
//            );
//          },
//        );
//      },
//    );
//  }

}
