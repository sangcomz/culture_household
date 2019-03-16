import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int _category = 0;
  int _userNumber = 0;
  String _money = '';
  final moneyController = TextEditingController();
  final descriptionController = TextEditingController();

  _categoryChanged(int value) {
    setState(() {
      _category = value;
    });
  }

  _userChanged(int value) {
    setState(() {
      _userNumber = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('사용자'),
                      ),
                      DropdownButton<int>(
                        value: _userNumber,
                        items: <DropdownMenuItem<int>>[
                          const DropdownMenuItem(
                              child: const Text('한사람🎃'), value: 0),
                          const DropdownMenuItem(
                              child: const Text('두사람🐔'), value: 1),
                        ],
                        onChanged: _userChanged,
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
                        debugPrint(descriptionController.text);
                        debugPrint(moneyController.text);
                      },
                      child: Text('추가'),
                    )),
              ),
            ],
          ),
        ));
  }

}
