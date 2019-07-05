import 'package:flutter/cupertino.dart';

Padding bmjuaText(String text, double textSize, TextAlign textAlign,
    [double lrPadding = 0, double tbPadding = 0]) {
  return Padding(
    padding: EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
    child: Text(text,
        textAlign: textAlign,
        style: TextStyle(fontFamily: 'bmjua', fontSize: textSize)),
  );
}

Padding hannaText(String text, double textSize, TextAlign textAlign,
    [double lrPadding = 0, double tbPadding = 0]) {
  return Padding(
    padding: EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
    child: Text(text,
        textAlign: textAlign,
        style: TextStyle(fontFamily: 'hanna', fontSize: textSize)),
  );
}
