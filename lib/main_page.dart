import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culture_household/ViewExt.dart';
import 'package:culture_household/add_page.dart';
import 'package:culture_household/category.dart';
import 'package:culture_household/group_manager.dart';
import 'package:culture_household/login_page.dart';
import 'package:culture_household/presentation/my_custom_icons.dart';
import 'package:culture_household/views.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser _user;
  final Group _group;

  MainPage(this._user, this._group);

  @override
  _MainPageState createState() {
    return _MainPageState(_user, _group);
  }
}

class _MainPageState extends State<MainPage> {
  final FirebaseUser _user;
  final Group _group;

  _MainPageState(this._user, this._group);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPage(_user, _group)));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(MyCustom.logout),
                onPressed: () {
                  logout(context);
                },
              )
            ],
            title: Text(
              '문화 가계부',
              style: TextStyle(fontFamily: 'bmjua'),
            )),
        body: getItemList(_user.uid, this._group));
  }

  Widget getItemList(String uid, Group group) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('household')
          .document(group.id)
          .collection('list')
          .orderBy('created_at', descending: true)
          .snapshots()
          .distinct()
          .handleError((onError) {
        print('onError  $onError');
      }),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('Empty'),
          );
        }
        var items = snapshot.data?.documents ?? [];
        if (items.length > 0) {
          List<HouseHold> _houseHoldList = items.map((document) {
            var data = document.data;
            bool checked = data['checked'] as bool ?? false;
            return HouseHold(
                data['id'],
                data['uid'],
                data['name'],
                data['profile'],
                data['created_at'],
                data['category'],
                data['money'],
                data['description'],
                checked,
                data['update_at']);
          }).toList();
          return Center(
            child: ListView.builder(
              key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, position) {
                  return MainItem(_houseHoldList[position], _group);
                }
                ),
          );
        } else {
          return Center(
            child: Text('Empty'),
          );
        }
      },
    );
  }

  void logout(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('로그아웃'),
            content: Text('로그아웃 하시겠습니까?'),
            actions: <Widget>[
              FlatButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('로그아웃'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          );
        });
  }
}

class HouseHold {
  String id;
  String uid;
  String name;
  String profile;
  int createdAt;
  int category;
  String money;
  String description;
  bool checked;
  int updateAt;

  HouseHold(this.id, this.uid, this.name, this.profile, this.createdAt,
      this.category, this.money, this.description,
      [this.checked = false, this.updateAt]);
}

class MainItem extends StatefulWidget {
  final HouseHold _houseHold;
  final Group _group;

  MainItem(this._houseHold, this._group);

  @override
  _MainItemState createState() {
    return _MainItemState(_houseHold, _group);
  }
}

class _MainItemState extends State<MainItem> {
  final HouseHold _houseHold;
  final Group _group;
  int _year;
  int _month;

  bool _isShowLoading = false;
  bool _checked;
  String _updateAt;

  _MainItemState(this._houseHold, this._group) {
    _checked = _houseHold.checked;
    var date = DateTime.fromMillisecondsSinceEpoch(_houseHold.createdAt);
    _year = date.year;
    _month = date.month;

    if (_houseHold.updateAt == null) {
      _updateAt = '-';
    } else {
      _updateAt = getUpdateDateString(_houseHold.updateAt);
    }
  }

  void _checkedChanged(bool value) {
    _isShowLoading = true;
    setState(() {
      updateHousehold(_houseHold.id, _group.id, value).then((mapEntry) {
        _isShowLoading = false;
        _checked = value;
        _updateAt = getUpdateDateString(mapEntry.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Card(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            '$_month월',
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            _year.toString(),
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            bmjuaText(getCategoryText(_houseHold.category), 24,
                                TextAlign.left, 0, 2),
                            hannaText('금액 : ${_houseHold.money}', 16,
                                TextAlign.left, 0, 4),
                            hannaText('내용 : ${_houseHold.description}', 16,
                                TextAlign.left, 0, 4),
                            hannaText('사용자 : ${_houseHold.name}', 16,
                                TextAlign.left, 0, 4),
                            hannaText(
                                '지급일 : $_updateAt', 16, TextAlign.left, 0, 4),
                          ],
                        ),
                      )
                    ],
                  ),
                  Checkbox(
                    onChanged: _checkedChanged,
                    value: _checked,
                  )
                ],
              )),
        ),
        _isShowLoading ? Center(child: CircularProgressIndicator()) : Center()
      ],
    );
  }

  Future<MapEntry<bool, int>> updateHousehold(
      String householdId, String groupId, bool checked) {
    int updateAt = 0;

    return Firestore.instance.runTransaction((Transaction tx) async {
      final DocumentReference householdRef =
          Firestore.instance.document('household/$groupId/list/$householdId');
      DocumentSnapshot groupSnapshot = await tx.get(householdRef);

      if (checked) updateAt = DateTime.now().millisecondsSinceEpoch;
      if (groupSnapshot.exists) {
        MapEntry<bool, int> isUpdated = await tx.update(
            householdRef, <String, dynamic>{
          'checked': checked,
          'update_at': updateAt
        }).then((_) {
          return MapEntry(checked, updateAt);
        }, onError: (error) {
          return MapEntry(!checked, updateAt);
        });
        return {isUpdated.key.toString(): isUpdated.value};
      }
    }).then((data) {
      return MapEntry(data.keys.first == 'true', data.values.first);
    }, onError: (error) {
      return null;
    });
  }

  String getUpdateDateString(int updateAt) {
    if (updateAt == 0) return '-';
    var updateDate = DateTime.fromMillisecondsSinceEpoch(updateAt);
    return '${updateDate.year}/${updateDate.month}/${updateDate.day}';
  }
}

void goMainPage(
    BuildContext context, Group group, GlobalKey<ScaffoldState> key) {
  FirebaseAuth.instance.currentUser().then((user) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => MainPage(user, group)));
  }, onError: (error) {
    showSnackBar(key, '일시적 오류입니다. 잠시후 다시 시도해주세요!');
  });
}
