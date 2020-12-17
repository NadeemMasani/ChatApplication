import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String base64;
  ImageDisplay({this.base64});

  Widget build(BuildContext context) {
    if (base64 == 'none' || base64 == null)
      return Center(
          child: Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: new Container(
                  child: Center(child: Text('No Image')),
                  width: 50,
                  height: 50)));
    Uint8List bytes = base64Decode(base64);

    return Center(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.memory(
        bytes,
        fit: BoxFit.fitWidth,
        width: 10,
        height: 10,
      ),
    ));
  }
}
