import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/screens/spotDetailsPage.dart';
import '../spot.dart';

class SpotList extends StatefulWidget {
  //store list items
  final List<Spot> listItems;
  final FirebaseUser user;
  final Function onGoBack;
  //initialize PostList
  SpotList(this.listItems, this.user, this.onGoBack);

  @override
  _SpotListState createState() => _SpotListState();
}

class _SpotListState extends State<SpotList> {

  void favorite(Function callback) {
    this.setState(() {
      callback();
    });
  }

  void changeNavigation(spot, user){
    Route route = MaterialPageRoute(builder: (context) => SpotDetailsPage(spot, user));
    Navigator.push(context, route).then(widget.onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index){
        //function for how to build each item
        var spot = this.widget.listItems[index];
        return Card(
            child: Row(children: <Widget>[
              Expanded(child: ListTile(
                  title: Text(spot.title),
                  subtitle: Text(spot.address),
                  onTap: () => changeNavigation(spot, widget.user),
              )),
              Row(children: <Widget>[
                Container(child: Text(
                    spot.favoriteList.length.toString(),
                    style: TextStyle(fontSize: 20)),
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0)
                ),
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () => this.favorite( () => spot.favoriteSpot(widget.user)),
                  color: spot.favoriteList.contains(widget.user.uid) ? Colors.red : Colors.black,
                )
              ],)
            ],)
        );
      },
    );
  }
}