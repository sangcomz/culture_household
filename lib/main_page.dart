import 'package:culture_household/add_page.dart';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPage()));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(title: Text('문화 가계부')),
        body: Center(
          child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, position) {
                return MainItem(position, false);
              }),
        ));
  }
}

class MainItem extends StatefulWidget {
  int position = 0;
  bool checked = false;

  MainItem(this.position, this.checked);

  @override
  _MainItemState createState() => _MainItemState();
}

class _MainItemState extends State<MainItem> {
  bool _checked = false;

  void _checkedChanged(bool value) => setState(() => _checked = value);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        '1월',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        '2019',
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '공부📚',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          '금액 : 30,000원',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text('내용 : Inflearn에서 Flutter 인강',
                            style: TextStyle(fontSize: 16)),
                        Text('사용자 : 정석원', style: TextStyle(fontSize: 16)),
                        Text(
                            '지급일 : 2019.3.27', style: TextStyle(fontSize: 16))
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
    );
  }
}
