import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/DataPassed.dart';
import '../spot.dart';
import 'modifySpotPage.dart';
import 'package:transparent_image/transparent_image.dart';


class SpotDetailsPage extends StatefulWidget {
  final DataPassed datapassed;

  //initialize SpotsMapPage with the name
  SpotDetailsPage(this.datapassed);
  @override
  _SpotDetailsPageState createState() => _SpotDetailsPageState();
}

class _SpotDetailsPageState extends State<SpotDetailsPage> {

  void moveToModifyDetails(){
    //Navigator.push(context, MaterialPageRoute(builder: (context)=> ModifySpotPage(widget.user, widget.spot)));
    DataPassed dataPassed = new DataPassed(user: widget.datapassed.user, spot: widget.datapassed.spot);
    Navigator.of(context).pushNamed('/modifySpot', arguments: dataPassed);
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
        actions: widget.datapassed.spot.authorId == widget.datapassed.user.uid ? [
          IconButton(icon: Icon(Icons.edit, color: Colors.white,),
              onPressed: () => moveToModifyDetails())
        ] : [],
      ),
      body: Column(children: [
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.favorite, color: widget.datapassed.spot.favoriteList.contains(widget.datapassed.user.uid) ? Colors.red : Colors.black,),
            onPressed: () => this.favorite( () => widget.datapassed.spot.favoriteSpot(widget.datapassed.user)),
          ),
          title: Text(widget.datapassed.spot.title),
          subtitle: Text(widget.datapassed.spot.address),
        ),
        widget.datapassed.spot.imageUrl != null ? Stack(
          children: [
            Center(child: Padding(padding: EdgeInsets.all(15),child:CircularProgressIndicator())),
            Center(
              child: FadeInImage.memoryNetwork(
                height: 200,
                placeholder: kTransparentImage,
                image: widget.datapassed.spot.imageUrl,
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
              widget.datapassed.spot.description,
              style: new TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.left,
            )),
          )
        ),
      ])
    );
  }
}

