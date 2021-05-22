import 'package:flutter/material.dart';

class ClassicButtonContainer extends StatelessWidget {

  final String text;
  final Color color;

  ClassicButtonContainer({this.text,this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20)),
      height: 55,
      width: 250,
      child: Center(
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
    );
  }
}