import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../spot.dart';
import 'modifySpotPage.dart';
import 'package:transparent_image/transparent_image.dart';


class SpotDetailsPage extends StatefulWidget {
  final FirebaseUser user;
  final Spot spot;

  //initialize SpotsMapPage with the name
  SpotDetailsPage(this.spot, this.user);
  @override
  _SpotDetailsPageState createState() => _SpotDetailsPageState();
}

class _SpotDetailsPageState extends State<SpotDetailsPage> {

  void moveToModifyDetails(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ModifySpotPage(widget.user)));
  }

  void favorite(Function callback) {
    this.setState(() {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Note the Spot'),
        actions: widget.spot.authorId == widget.user.uid ? [
          IconButton(icon: Icon(Icons.edit, color: Colors.white,),
              onPressed: () => moveToModifyDetails())
        ] : [],
      ),
      body: Column(children: [
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.favorite, color: widget.spot.favoriteList.contains(widget.user.uid) ? Colors.red : Colors.black,),
            onPressed: () => this.favorite( () => widget.spot.favoriteSpot(widget.user)),
          ),
          title: Text(widget.spot.title),
          subtitle: Text(widget.spot.address),
        ),
        widget.spot.imageUrl != null ? Stack(
          children: [
            Center(child: Padding(padding: EdgeInsets.all(15),child:CircularProgressIndicator())),
            Center(
              child: FadeInImage.memoryNetwork(
                height: 200,
                placeholder: kTransparentImage,
                image: widget.spot.imageUrl,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
          )
            : Text(""),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0), child:Text(
              widget.spot.description,
              style: new TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.left,
            )),
          )
        ),
      ])
    );
  }
}

