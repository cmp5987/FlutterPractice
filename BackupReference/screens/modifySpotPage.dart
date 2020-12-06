import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blog/firebase/database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../spot.dart';


class ModifySpotPage extends StatefulWidget {
  final FirebaseUser user;
  //initialize SpotsMapPage with the name
  ModifySpotPage(this.user);

  @override
  _ModifySpotPageState createState() => _ModifySpotPageState();
}

class _ModifySpotPageState extends State<ModifySpotPage> {

  //used for validating the form
  final _formKey = GlobalKey<FormState>();

  File _image;

  //textfield controllers
  TextEditingController titleController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
  newSpot(String spotAddress, String spotTitle, String spotDescription, BuildContext context){
    var spot = new Spot(widget.user.uid, widget.user.displayName, spotAddress, spotTitle, spotDescription);
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Note the Spot'),
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
                              child: (_image != null) ? Image.file(_image,  height: 75, width: 100, fit: BoxFit.fitHeight) : Image.asset('assets/placeholder_image.png', height: 75, width: 75, fit: BoxFit.fitHeight),
                            )
                        ),
                        RaisedButton.icon(onPressed: this.getImage, icon: Icon(Icons.camera_alt, color: Colors.white,), label: Text("Select Image", style: TextStyle(color: Colors.white),), color: Colors.red),
                      ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          newSpot(addressController.text, addressController.text, descriptionController.text, context);
                          Navigator.pop(context);
                        }
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
