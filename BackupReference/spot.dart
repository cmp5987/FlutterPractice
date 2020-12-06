import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase/database.dart';

class Spot{
  DatabaseReference _id;
  String authorId;
  String author;
  String address;
  String title;
  String description;
  String imageUrl;
  Set favoriteList = {};

  //initialize Spot
  Spot(this.authorId, this.author, this.address, this.title, this.description);

  void setId(DatabaseReference id){
    this._id = id;
  }
  void setAuthorId(String uid){
    this.authorId = uid;
  }
  void setImageUrl(String url){
    this.imageUrl = url;
  }
  void setTitle(String newTitle){
    this.title = newTitle;
  }
  void setAddress(String newAddress){
    this.address = newAddress;
  }
  void setDescription(String newDescription){
    this.description = newDescription;
  }
  DatabaseReference getId(){
    return this._id;
  }

  void favoriteSpot(FirebaseUser user){
    //allow the modifying of like for the user
    if(this.favoriteList.contains(user.uid)){
      this.favoriteList.remove(user.uid);
    }
    else{
      this.favoriteList.add(user.uid);
    }
    this.update();
  }

  void update(){
    //call database here
    updateSpot(this, this._id);
  }

  Map<String, dynamic> toJson(){
    //returns map of the post to a json
    return {
      'authorId': this.authorId,
      'author': this.author,
      'address': this.address,
      'title': this.title,
      'favoriteList': this.favoriteList.toList(),
      'description': this.description,
      'imageUrl': this.imageUrl
    };
  }
}
Spot createSpot(record){
  //create empty Post
  Map<String, dynamic> attributes = {
    'authorId': '',
    'author': '',
    'address': '',
    'title': '',
    'favoriteList': [],
    'description': '',
    'imageUrl': null
  };
  record.forEach((key,value) => {
    //populate attributes
    attributes[key] = value
  });

  Spot spot = new Spot(attributes['authorId'],attributes['author'], attributes['address'], attributes['title'], attributes['description']);
  spot.imageUrl = attributes['imageUrl'];
  spot.favoriteList = new Set.from(attributes['favoriteList']);
  return spot;
}