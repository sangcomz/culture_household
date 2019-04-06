import 'package:culture_household/BaseStatefulWidget.dart';
import 'package:culture_household/ViewExt.dart';
import 'package:culture_household/group_manager.dart';
import 'package:culture_household/main_page.dart';
import 'package:culture_household/views.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupPage extends BaseStatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final existGroupController = TextEditingController();
  final newGroupController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
        '그룹 설정',
        style: TextStyle(fontFamily: 'bmjua'),
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              bmjuaText('기존 그룹 가입', 24, TextAlign.center),
              Padding(
                  padding: EdgeInsets.fromLTRB(80, 16, 80, 16),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: existGroupController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: '그룹 아이디를 입력해주세요.',
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontFamily: 'bmjua')),
                  )),
              Center(
                child: FlatButton(
                  padding: EdgeInsets.all(16),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text(
                    '참여하기 🤟🏻',
                    style: TextStyle(fontFamily: 'bmjua', fontSize: 24),
                  ),
                  onPressed: () {
                    if (existGroupController.text.isEmpty) {
                      showSnackBar(_scaffoldKey, '그룹 아이디를 입력해주세요.');
                    } else {
                      _joinGroup();
                    }
                  },
                ),
              )
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          Column(
            children: <Widget>[
              bmjuaText('새로운 그룹 만들기', 24, TextAlign.center),
              Padding(
                  padding: EdgeInsets.fromLTRB(80, 16, 80, 16),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: newGroupController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: '그룹 아이디를 입력해주세요.',
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontFamily: 'bmjua')),
                  )),
              Center(
                child: FlatButton(
                  padding: EdgeInsets.all(16),
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text(
                    '생성하기 🤟🏻',
                    style: TextStyle(fontFamily: 'bmjua', fontSize: 24),
                  ),
                  onPressed: () {
                    if (newGroupController.text.isEmpty) {
                      showSnackBar(_scaffoldKey, '그룹 아이디를 입력해주세요.');
                    } else {
                      _addNewGroup();
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _addNewGroup() {
    var groupName = newGroupController.text;
    isExistGroup(groupName).then((group) {
      if (group != null) {
        showSnackBar(_scaffoldKey, '이미 존재하는 그룹 아이디입니다.');
      } else {
        createGroup(groupName).then((created) {
          if (created) {
            goMainPage(group);
          } else {
            showSnackBar(_scaffoldKey, '일시적 오류입니다. 잠시후 다시 시도해주세요!');
          }
        }).catchError((error) {
          print('error !! $error');
        });
      }
    });
  }

  void _joinGroup() {
    var groupName = existGroupController.text;
    isExistGroup(groupName).then((group) {
      if (group != null) {
        joinGroup(groupName).then((data) {
          if (data) {
            goMainPage(group);
          } else {
            showSnackBar(_scaffoldKey, '일시적 오류입니다. 잠시후에 다시 시도해주세요.');
          }
        }, onError: (error) {
          print('update users error3 $error');
          showSnackBar(_scaffoldKey, '일시적 오류입니다. 잠시후에 다시 시도해주세요.');
        });
      } else {
        showSnackBar(_scaffoldKey, '존재하지 않는 그룹 아이디입니다.');
      }
    });
  }

  void goMainPage(Group group) {
    FirebaseAuth.instance.currentUser().then((user) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MainPage(user, group)));
    }, onError: (error) {
      showSnackBar(_scaffoldKey, '일시적 오류입니다. 잠시후 다시 시도해주세요!');
    });
  }
}
