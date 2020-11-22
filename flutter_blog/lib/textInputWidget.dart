import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  //property of this class that is a call back with a string as the argument
  final Function(String) callback;

  //constructor that defines callback
  //initializes callback
  //[] unnamed optional where {} optional but named
  TextInputWidget(this.callback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  // object to modify and figure out the contents of what is typed by user
  final controller = TextEditingController();

  //when we dispose of widget, we dispose the controller
  //remove object from memory
  //this already is in parent class
  @override
  void dispose(){
    super.dispose();
    //adding dispose of controller as well
    controller.dispose();
  }

  void click() {
    //references the class
    //means we can access the callback
    widget.callback(controller.text);
    FocusScope.of(context).unfocus();
    controller.clear(); //clear text input field

  }


  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: this.controller,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.message),
            labelText: "Type a message:",
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              splashColor: Colors.blue,
              tooltip: "Post message",
              onPressed: this.click,
            )
        )
    );
  }
}