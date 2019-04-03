import 'package:culture_household/BaseStatefulWidget.dart';
import 'package:culture_household/group_manager.dart';
import 'package:culture_household/main_page.dart';
import 'package:culture_household/views.dart';
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
                      _showSnackBar('그룹 아이디를 입력해주세요.');
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
                      _showSnackBar('그룹 아이디를 입력해주세요.');
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
    isExistGroup(groupName).then((isExist) {
      if (isExist) {
        _showSnackBar('이미 존재하는 그룹 아이디입니다.');
      } else {
        createGroup(groupName).then((created) {
          if (created) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          } else {
            _showSnackBar('일시적 오류입니다. 잠시후 다시 시도해주세요!');
          }
        }).catchError((error) {
          print('error !! $error');
        });
      }
    });
  }

  void _joinGroup() {
    var groupName = existGroupController.text;
    isExistGroup(groupName).then((isExist) {
      if (isExist) {
        joinGroup(groupName).then((data) {
          if (data) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          } else {
            _showSnackBar('일시적 오류입니다. 잠시후에 다시 시도해주세요.');
          }
        }, onError: (error) {
          print('update users error3 $error');
          _showSnackBar('일시적 오류입니다. 잠시후에 다시 시도해주세요.');
        });
      } else {
        _showSnackBar('존재하지 않는 그룹 아이디입니다.');
      }
    });
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
