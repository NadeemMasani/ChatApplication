import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const formInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  labelStyle: TextStyle(
    color: Colors.black,
  ),
  contentPadding: EdgeInsets.all(6.0),
  enabledBorder: UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.black45, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
  ),
);

const boxDecoration = BoxDecoration(
  gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
  borderRadius: BorderRadius.all(Radius.circular(50.0)),
);

final Shader linearGradient = LinearGradient(
  colors: <Color>[Colors.orangeAccent, Colors.red],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
