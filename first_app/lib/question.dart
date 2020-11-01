import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  //"final" can be used to say that this String iwll never changed after it is created
  final String questionText;

  //positional argument
  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }
}
