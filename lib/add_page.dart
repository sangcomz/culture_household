import 'package:culture_household/ViewExt.dart';
import 'package:culture_household/group_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'BaseStatefulWidget.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class AddPage extends BaseStatefulWidget {
  final FirebaseUser _user;
  final Group _group;

  AddPage(this._user, this._group);

  @override
  _AddPageState createState() => _AddPageState(_user, _group);
}

class _AddPageState extends State<AddPage> {
  final FirebaseUser _user;
  final Group _group;

  _AddPageState(this._user, this._group);

  int _category = 0;
  final moneyController = MoneyMaskedTextController(
      initialValue: 0, precision: 3, thousandSeparator: ',', rightSymbol: '원');
  final descriptionController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _showLoading = false;

  _categoryChanged(int value) {
    setState(() {
      _category = value;
    });
  }

  _loadingState(bool isShow) {
    setState(() {
      _showLoading = isShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('문화생활 추가'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('카테고리'),
                      ),
                      DropdownButton<int>(
                        value: _category,
                        items: <DropdownMenuItem<int>>[
                          const DropdownMenuItem(
                            child: const Text('자기개발📚'),
                            value: 0,
                          ),
                          const DropdownMenuItem(
                              child: const Text('문화활동🖋'), value: 1),
                          const DropdownMenuItem(
                              child: const Text('운동🤺'), value: 2),
                          const DropdownMenuItem(
                              child: const Text('기타🎸'), value: 3),
                        ],
                        onChanged: _categoryChanged,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: moneyController,
                    decoration: InputDecoration(
                        labelText: '금액',
                        hintText: '사용 금액을 입력해주세요.',
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        labelText: '내용',
                        hintText: '내용을 입력해주세요.',
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
              SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: FlatButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        _loadingState(true);
                        _addCultureHousehold(_user, _group);
                      },
                      child: Text('추가'),
                    )),
              ),
            ],
          ),
        ),
      ),
      _showLoading
          ? Container(
              color: Color.fromRGBO(1, 1, 1, 0.5),
              child: Center(child: CircularProgressIndicator()),
            )
          : Center()
    ]);
  }

  void _addCultureHousehold(FirebaseUser user, Group group) {
    final Firestore firestore = Firestore.instance;

    if (moneyController.text.isEmpty) {
      showSnackBar(_scaffoldKey, '금액을 입력해주세요!');
      return;
    }

    if (descriptionController.text.isEmpty) {
      showSnackBar(_scaffoldKey, '내용을 입력해주세요!');
      return;
    }
    var doc = firestore
        .collection('household')
        .document(group.id)
        .collection('list')
        .document();
    doc.setData({
      'id': doc.documentID,
      'uid': user.uid,
      'name': user.displayName,
      'profile': user.photoUrl,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'category': _category,
      'money': moneyController.text,
      'description': descriptionController.text
    }).then((onValue) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
    });
  }
}
