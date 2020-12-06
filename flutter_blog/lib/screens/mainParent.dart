import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blog/DataPassed.dart';
import 'package:flutter_blog/customWidgets/mapWidgets.dart';
import 'package:flutter_blog/customWidgets/spotList.dart';
import 'package:flutter_blog/firebase/database.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../spot.dart';

/// This is the stateful widget that the main application instantiates.
class MainParent extends StatefulWidget {
  final DataPassed datapassed;
  //initialize SpotsMapPage with the name
  MainParent(this.datapassed);

  @override
  _MainParentState createState() => _MainParentState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MainParentState extends State<MainParent> {
  int _selectedIndex = 1;
  String _selectedString = "1";

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Spot> spots = [];
  List<Spot> mySpots = [];

  void updateSpots(){
    getAllSpots().then( (spots) => {
      this.setState(() {
        this.spots = spots;
        this.mySpots = spots.where( (spot) => spot.authorId == widget.datapassed.user.uid).toList();
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
    updateSpots();
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedString = index.toString();
    });
  }
  void navigateModifyPage() {
    Navigator.of(context).pushNamed('/modifySpot', arguments: widget.datapassed).then(onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note The Spot'),
      ),
      body: Center(
        child: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => _selectedString,
          caseBuilders: {
            '0': (BuildContext context) => MapWidgets(widget.datapassed.user, this.spots, onGoBack),
            '1': (BuildContext context) => Scaffold(body: Column(children: <Widget>[Expanded(child: SpotList(this.spots, widget.datapassed.user, onGoBack)),]),),
            '2': (BuildContext context) => Scaffold(body: Column(children: <Widget>[Expanded(child: SpotList(this.spots, widget.datapassed.user, onGoBack)),]), floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () {navigateModifyPage();})),
          },
          fallbackBuilder: (BuildContext context) => Text('None of the cases matched!'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Spots Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Spots List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Spots',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
