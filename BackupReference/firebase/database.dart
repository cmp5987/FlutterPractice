import 'package:firebase_database/firebase_database.dart';
import '../spot.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference saveSpot(Spot spot){
  var id = databaseReference.child('spots/').push();
  id.set(spot.toJson());
  return id;
}
void updateSpot(Spot spot, DatabaseReference id){
  id.update(spot.toJson());
}
void deleteSpot(DatabaseReference id){
  id.remove();
}

Future<List<Spot>> getAllSpots() async {
  //async call to posts
  DataSnapshot dataSnapshot = await databaseReference.child('spots/').once();
  List<Spot> spots = [];
  if(dataSnapshot.value != null){
    //for every value in the lis there will be a key that we can turn into Post
    dataSnapshot.value.forEach((key, value){
      //key = uid
      //value = the object
      Spot spot = createSpot(value);
      //we want to pass the database reference not just the string that is the key
      spot.setId(databaseReference.child('spots/' + key));
      spots.add(spot);
    });
    return spots;
  }

  return [];
}
Future<List<Spot>> getFavoriteSpots() async {
  //async call to spots
  DataSnapshot dataSnapshot = await databaseReference.child('stops/').once();
  List<Spot> spots = [];
  if(dataSnapshot.value != null){
    //for every value in the lis there will be a key that we can turn into Spots
    dataSnapshot.value.forEach((key, value){
      //key = uid
      //value = the object
      Spot spot = createSpot(value);
      //we want to pass the database reference not just the string that is the key
      spot.setId(databaseReference.child('spots/' + key));

      spots.add(spot);
    });
    return spots;
  }

  return [];
}
Future<List<Spot>> getMySpots() async {
  //async call to spots
  DataSnapshot dataSnapshot = await databaseReference.child('spots/').once();
  List<Spot> spots = [];
  if(dataSnapshot.value != null){
    //for every value in the lis there will be a key that we can turn into Spots
    dataSnapshot.value.forEach((key, value){
      //key = uid
      //value = the object
      Spot spot = createSpot(value);
      //we want to pass the database reference not just the string that is the key
      spot.setId(databaseReference.child('spots/' + key));
      spots.add(spot);
    });

    return spots;
  }

  return [];
}

