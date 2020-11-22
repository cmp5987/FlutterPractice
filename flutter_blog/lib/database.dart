import 'package:firebase_database/firebase_database.dart';
import 'post.dart';

final databaseReference = FirebaseDatabase.instance.reference();

//adding to the database
//take the post object and save it in the database
DatabaseReference savePost(Post post) {
  //there are children in the database that are the different sections of items
  //reference something call post within the database, if that doesn't exist then it creates a new one
  //posts is a child that is directory because of the slash
  //push gives us a database reference that we can store inside of post
  var id = databaseReference.child('posts/').push();
  //id is a placeholder item
  //put id as json serializable object
  id.set(post.toJson());
  return id;
}

//take post object and database id and lets update the database
void updatePost(Post post, DatabaseReference id){
  id.update(post.toJson());
}

Future<List<Post>> getAllPosts() async {
  //async call to posts
  DataSnapshot dataSnapshot = await databaseReference.child('posts/').once();
  List<Post> posts = [];
  if(dataSnapshot.value != null){
    //for every value in the lis there will be a key that we can turn into Post
    dataSnapshot.value.forEach((key, value){
      //key = uid
      //value = the object
      Post post = createPost(value);
      //we want to pass the database reference not just the string that is the key
      post.setId(databaseReference.child('posts/' + key));
      posts.add(post);
    });
    return posts;
  }

  return [];
}