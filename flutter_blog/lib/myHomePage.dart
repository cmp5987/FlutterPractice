import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'post.dart';
import 'postList.dart';
import 'textInputWidget.dart';


class MyHomePage extends StatefulWidget {
  final FirebaseUser user;

  //initialize homepage with the name
  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  void newPost(String text){
    var post = new Post(text, widget.user.displayName);
    post.setId(savePost(post));
    setState(() {
       posts.add(post);
    });
  }

  void updatePosts(){
    getAllPosts().then( (posts) => {
      this.setState(() {
        this.posts = posts;
      })
    });
  }

  @override
  void initState(){
    super.initState();
    updatePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Blog App")),
        body: Column(children: <Widget>[
          //makes sure everything we have as a child fills up the full space
          Expanded(child: PostList(this.posts, widget.user)),
          TextInputWidget(this.newPost)
        ]));
  }
}
