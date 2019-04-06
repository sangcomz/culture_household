import 'package:culture_household/ViewExt.dart';
import 'package:culture_household/group_manager.dart';
import 'package:culture_household/group_page.dart';
import 'package:culture_household/main_page.dart';
import 'package:culture_household/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: bmjuaText('🧾\n문화가계부', 36, TextAlign.center)),
              SizedBox(
                height: 40,
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () {
                    _handleGoogleSignIn().then((user) {
                      joinedGroup(user.uid).then((group) {
                        if (group != null) {
                          goMainPage(context, group, _scaffoldKey);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupPage()));
                        }
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    FirebaseUser user = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken));
    return user;
  }
}
