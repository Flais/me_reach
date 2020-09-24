import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double _height;
  final double _width;

  AppLogo({
    double height = 100,
    double width = 100,
  })  : this._height = height,
        this._width = width;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/images/logo.png',
        height: this._height,
        width: this._width,
      ),
    );
  }
}
