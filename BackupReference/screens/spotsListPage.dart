import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/customWidgets/spotList.dart';
import 'package:flutter_blog/firebase/database.dart';


import '../spot.dart';
import 'modifySpotPage.dart';

class SpotsListPage extends StatefulWidget {
  final FirebaseUser user;

  //initialize SpotsMapPage with the name
  SpotsListPage(this.user);

  @override
  _SpotsListPageState createState() => _SpotsListPageState();
}

class _SpotsListPageState extends State<SpotsListPage> {
  List<Spot> spots = [];

  void updateSpots(){
    getAllSpots().then( (spots) => {
      this.setState(() {
        this.spots = spots;
      })
    });
  }

  @override
  void initState(){
    super.initState();
    updateSpots();
  }

  //update list
  FutureOr onGoBack(dynamic value) {
    getAllSpots().then( (spots) => {
      this.setState(() {
        this.spots = spots;
      })
    });
  }
  void navigateModifyPage() {
    Route route = MaterialPageRoute( builder: (context) => ModifySpotPage(widget.user));
    Navigator.pushReplacement(context, route).then(onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Note the Spot")),
        body: Column(children: <Widget>[
          //makes sure everything we have as a child fills up the full space
          Expanded(child: SpotList(this.spots, widget.user, onGoBack)),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            navigateModifyPage();
          }
        )
    );
  }
}
