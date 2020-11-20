import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blog App")),
      body: TextInputWidget());
  }
}

class TextInputWidget extends StatefulWidget {
  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  // object to modify and figure out the contents of what is typed by user
  final controller = TextEditingController();
  String text = "";

  //when we dispose of widget, we dispose the controller
  //remove object from memory
  //this already is in parent class
  @override
  void dispose(){
    super.dispose();
    //adding dispose of controller as well
    controller.dispose();
  }
  
  void changeText(text){
    //modify stored text
    if(text == "Hello World!"){
      controller.clear();
      text = "";
    }
    setState( (){
      //this adjusts the texts because the state of the app has changed
      this.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          TextField(
            controller: this.controller,
            decoration: InputDecoration(prefixIcon: Icon(Icons.message), labelText: "Type a message:"),
            onChanged: (text) => this.changeText(text),
        ),
        Text(this.text)
        ]);
  }
}
