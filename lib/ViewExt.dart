import 'package:flutter/material.dart';

void showSnackBar(GlobalKey<ScaffoldState> key, String message) {
  final snackBar = SnackBar(content: Text(message));
  key.currentState.showSnackBar(snackBar);
}