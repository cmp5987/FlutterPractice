import 'package:first_app/question.dart';

import 'package:flutter/material.dart';
import 'quiz.dart';
import 'result.dart';

//shorthand for function with one line of code in the expression
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    //throw UnimplementedError();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _questions = const [
    {
      "questionText": "What's your favorite color?",
      "answers": [
        "Black",
        "Red",
        "Green",
        "white",
      ],
    },
    {
      "questionText": "What's your favorite animal?",
      "answers": [
        "Dog",
        "Cat",
        "Mouse",
        "Rabbit",
        "Lion",
      ],
    },
    {
      "questionText": "What is your favorite candy?",
      "answers": [
        "Skittles",
        "M&M",
        "Gum",
        "Starbursts",
        "SweetishFish",
      ],
    },
  ];
  var _questionIndex = 0;

  void _answerQuestion() {
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    if (_questionIndex < _questions.length) {
      print("We have more questions here");
    } else {
      print("No more questions");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(),
      ),
    );
  }
}
