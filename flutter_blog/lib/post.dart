import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class Post{
  //id associated with post in the database
  DatabaseReference _id;
  String body;
  String author;
  //set will store the ids of users who liked the posts
  //sets are faster to store contains and removes than list but list is requried for databse
  Set usersLiked = {};

  //initialize with these Strings
  Post(this.body,
      this.author);

  void likePost(FirebaseUser user){
    //allow the modifying of like for the user
    if(this.usersLiked.contains(user.uid)){
      this.usersLiked.remove(user.uid);
    }
    else{
      this.usersLiked.add(user.uid);
    }
    this.update();
  }

  void update(){
    updatePost(this, this._id);
  }

  void setId(DatabaseReference id){
    this._id = id;
  }

  Map<String, dynamic> toJson(){
    //returns map of the post to a json
    return {
      'author': this.author,
      'usersLiked': this.usersLiked.toList(),
      'body': this.body
    };
  }
}
Post createPost(record){
  //create empty Post
  Map<String, dynamic> attributes = {
    'author': '',
    'usersLiked': [],
    'body': ''
  };
  record.forEach((key,value) => {
    //populate attributes
    attributes[key] = value
  });

  Post post = new Post(attributes['body'], attributes['author']);
  post.usersLiked = new Set.from(attributes['usersLiked']);
  return post;
}