import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blog/DataPassed.dart';
import 'package:flutter_blog/firebase/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:transparent_image/transparent_image.dart';
import '../spot.dart';


class ModifySpotPage extends StatefulWidget {
  final DataPassed dataPassed;

  //initialize SpotsMapPage with the name
  ModifySpotPage(this.dataPassed);

  @override
  _ModifySpotPageState createState() => _ModifySpotPageState();
}

class _ModifySpotPageState extends State<ModifySpotPage> {

  //used for validating the form
  final _formKey = new GlobalKey<FormState>();

  File _image;
  double lat;
  double long;

  //textfield controllers
  TextEditingController titleController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  initState(){
    super.initState();
  }
  

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
  newSpot(String spotAddress, String spotTitle, String spotDescription, double latitude, double longitude, BuildContext context){
    var spot = new Spot(widget.dataPassed.user.uid, widget.dataPassed.user.displayName, spotAddress, latitude, longitude, spotTitle, spotDescription);
    spot.setId(saveSpot(spot));
    //now upload the image

    if(_image != null) {
      //upload picture
      uploadPic(spot, context);
    }
    else{
      //no image given
      Navigator.of(context).pop();
    }
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('new spot added')));
  }
  modifySpot(String spotAddress, String spotTitle, String spotDescription, double latitude, double longitude, BuildContext context) {
    widget.dataPassed.spot.setTitle(spotTitle);
    widget.dataPassed.spot.setAddress(spotAddress);
    widget.dataPassed.spot.setDescription(spotDescription);
    widget.dataPassed.spot.setLatitude(latitude);
    widget.dataPassed.spot.setLongitude(longitude);
    updateSpot(widget.dataPassed.spot, widget.dataPassed.spot.getId());

    if(_image != null){
      uploadPic(widget.dataPassed.spot, context);
    }
    else{
      Navigator.of(context).pop();
    }
  }

  Future uploadPic(Spot spot, BuildContext context) async{

    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('spots/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    await uploadTask.onComplete;

    firebaseStorageRef.getDownloadURL().then((fileURL) {
      spot.setImageUrl(fileURL);
      updateSpot(spot, spot.getId());
      Navigator.of(context).pop();
    });
  }
  loadPageContent(){
    if(widget.dataPassed.spot != null){
      titleController.text = widget.dataPassed.spot.title;
      addressController.text = widget.dataPassed.spot.address;
      descriptionController.text = widget.dataPassed.spot.description;
    }
  }
  Widget findImageToDisplay(){
    //(_image != null) ? Image.file(_image,  height: 75, width: 100, fit: BoxFit.fitHeight) : Image.asset('assets/placeholder_image.png', height: 75, width: 75, fit: BoxFit.fitHeight),
    if(_image != null){
      //User has selected a new image
      return Image.file(_image,  height: 75, width: 100, fit: BoxFit.fitHeight);
    }
    else{
      //figure out if we have an image stored from spot to use
      if(widget.dataPassed.spot != null && widget.dataPassed.spot.imageUrl != null){
        return FadeInImage.memoryNetwork(
          height: 75,
          width: 100,
          placeholder: kTransparentImage,
          image: widget.dataPassed.spot.imageUrl,
          fit: BoxFit.fitHeight,
        );
      }
      else{
        return Image.asset('assets/placeholder_image.png', height: 75, width: 75, fit: BoxFit.fitHeight);
      }
    }
  }
  void removeSpotThenReturn(BuildContext context){
    deleteSpot(widget.dataPassed.spot.getId());
    var data = new DataPassed(user: widget.dataPassed.user);
    Fluttertoast.showToast(msg: "Spot successfully deleted");
    Navigator.of(context).pushNamed('/mainTabs', arguments: data);
  }

  checkAddressThenSubmit(context) async {
    var query = addressController.text;

    var address = await Geocoder.local.findAddressesFromQuery(query);

    this.setState(() {
      this.lat = (address.first.coordinates.latitude);
      this.long = address.first.coordinates.longitude;
    });

    if (_formKey.currentState.validate()) {
      if(widget.dataPassed.spot != null){
        modifySpot(addressController.text, titleController.text, descriptionController.text, this.lat, this.long, context);
      }
      else{
        newSpot(addressController.text, titleController.text, descriptionController.text, this.lat, this.long, context);
      }
      //Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    loadPageContent();
    return Scaffold(
        appBar: AppBar(
          title: Text('Note the Spot'),
          actions: widget.dataPassed.spot != null ? [
            IconButton(icon: Icon(Icons.delete, color: Colors.white,),
              onPressed: () => { removeSpotThenReturn(context) },
            )] : [],
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.tapas),
                      labelText: "Enter Spot title...",
                    ),
                    controller: titleController,
                  ),
                  TextFormField(
                    validator: (value){
                      if (value.isEmpty) {
                        return 'Please enter an address';
                      }
                      else if(lat == null || long == null){
                        return "Issue with entered address";
                      }
                      //TODO Validate Address
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on_sharp),
                      labelText: "Enter Spot Address...",
                    ),
                    controller: addressController,
                  ),
                  TextFormField(
                    validator: (value){
                      if (value.isEmpty) {
                        return 'Please enter a description';
                      }
                      //TODO Validate Address
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description_outlined),
                        labelText: "Enter Spot Description..."
                    ),
                    maxLines: 8,
                    controller: descriptionController,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Hero(
                                tag: 'hero',
                                child: findImageToDisplay()

                              //(_image != null) ? Image.file(_image,  height: 75, width: 100, fit: BoxFit.fitHeight) : Image.asset('assets/placeholder_image.png', height: 75, width: 75, fit: BoxFit.fitHeight),
                            )
                        ),
                        RaisedButton.icon(onPressed: this.getImage, icon: Icon(Icons.camera_alt, color: Colors.white,), label: Text("Select Image", style: TextStyle(color: Colors.white),), color: Colors.red),
                      ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        checkAddressThenSubmit(context);
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
