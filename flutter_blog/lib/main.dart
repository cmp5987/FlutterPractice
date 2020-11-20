import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Post{
  String body;
  String author;
  int likes = 0;
  bool userLiked = false;

  //initialize with these Strings
  Post(this.body,
    this.author);

  void likePost(){
    this.userLiked = !this.userLiked;

    //allow the modifying of like for the user
    if(this.userLiked){
      this.likes += 1;
    }
    else{
      this.likes -= 1;
    }

  }
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  void newPost(String text){
    setState(() {
      posts.add(new Post(text, "Catie"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Blog App")),
        body: Column(children: <Widget>[
          //makes sure everything we have as a child fills up the full space
          Expanded(child: PostList(this.posts)),
          TextInputWidget(this.newPost)
        ]));
  }
}


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

class PostList extends StatefulWidget {
  //store list items
  final List<Post> listItems;
  
  //initialize PostList
  PostList(this.listItems);
  
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void like(Function callback) {
    this.setState(() {
      callback();
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index){
        //function for how to build each item
        var post = this.widget.listItems[index];
        return Card(
          child: Row(children: <Widget>[
            Expanded(child: ListTile(
              title: Text(post.body),
              subtitle: Text(post.author)
            )),
            Row(children: <Widget>[
              Container(child: Text(
                  post.likes.toString(),
                  style: TextStyle(fontSize: 20)),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0)
              ),
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () => this.like(post.likePost),
                color: post.userLiked ? Colors.green : Colors.black,
              )
            ],)
          ],)
        );
      },
    );
  }
}

