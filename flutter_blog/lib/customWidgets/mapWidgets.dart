import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';

import '../DataPassed.dart';
import '../spot.dart';

class MapWidgets extends StatefulWidget {
  final List<Spot> spots;
  final FirebaseUser user;
  final Function onGoBack;

  MapWidgets(this.user, this.spots, this.onGoBack);

  @override
  _MapWidgetsState createState() => _MapWidgetsState();
}

class _MapWidgetsState extends State<MapWidgets> {

  final PopupController _popupController = PopupController();

  List<Marker> markers;
  int pointIndex;
  List points = [
    LatLng(43.156578, -77.608849),
    LatLng(49.8566, 3.3522),
  ];
  double zoomLevel = 5;

  @override
  void initState() {
    super.initState();

    this.setState(() {
      pointIndex = 0;
      markers = (widget.spots).map<Marker>((spot) =>
          Marker(
            anchorPos: AnchorPos.align(AnchorAlign.center),
            height: 30,
            width: 30,
            point: LatLng(spot.latitude, spot.longitude),
            builder: (ctx) => Icon(Icons.location_on, color: Colors.red,),
          )
      ).toList();
    });
    //print('initState() ---> ${widget.spots[0]}');
  }

  void changeNavigation(spot, user){
    //Route route = MaterialPageRoute(builder: (context) => SpotDetailsPage(spot, user));
    DataPassed dataPassed = new DataPassed(user: user, spot: spot);
    Navigator.of(context).pushNamed('/spotDetails', arguments: dataPassed).then(widget.onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: points[0],
          zoom: zoomLevel,
          plugins: [
            MarkerClusterPlugin(),
          ],
          onTap: (_) => _popupController
              .hidePopup(), // Hide popup when the map is tapped.
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            disableClusteringAtZoom: 6,
            size: Size(40, 40),
            anchor: AnchorPos.align(AnchorAlign.center),
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: markers,
            polygonOptions: PolygonOptions(
                borderColor: Colors.transparent,
                color: Colors.transparent,
                borderStrokeWidth: 1),
            popupOptions: PopupOptions(
                popupSnap: PopupSnap.top,
                popupController: _popupController,
                popupBuilder: (_, marker) => Container(
                  width: 300,
                  height: 100,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () => changeNavigation(widget.spots[this.markers.indexOf(marker)], widget.user),
                    child: Expanded(child: ListTile(
                          title: Text(widget.spots[this.markers.indexOf(marker)].title),
                        subtitle: Text(widget.spots[this.markers.indexOf(marker)].address),
                      )
                    ),
                  ),
                )),
            builder: (context, markers) {
              return FloatingActionButton(
                child: Text(markers.length.toString()),
                onPressed: null,
              );
            },
          ),
        ],
      ),
    );
  }
}
