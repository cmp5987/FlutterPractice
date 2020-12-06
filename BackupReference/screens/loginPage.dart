import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/screens/spotsListPage.dart';
import '../firebase/auth.dart';

class LoginPage extends StatelessWidget {

  final logo = Padding(
    padding: EdgeInsets.all(20),
    child: Hero(
        tag: 'hero',
        child: Image.asset('assets/notethespot.png', height: 100, width: 100, fit: BoxFit.fitHeight),
        )
    );

  final introCard = Container(
      padding: EdgeInsets.fromLTRB(5, 40, 5, 40),
      decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]
      ),
      child: Column(children: [
        Text("Note the Spot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.white, fontFamily: 'Raleway'), textAlign: TextAlign.center),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
          child: Text("Explore the known stories tied to each spot.", style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Raleway'), textAlign: TextAlign.center),
        )
      ])
  );

  @override
  Widget build(BuildContext context) {
      return SafeArea(
          child: Scaffold(
            body: Center(
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/LoginBackground.png"), fit: BoxFit.cover)
                ),
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    children: <Widget>[
                      logo,
                      introCard,
                      Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0), child: Body())
                    ],
                  ),
                ),
              ),
            ),
          )
      );
    }
}



class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //this is making reference to auth.dart
  FirebaseUser user;

  //lifecycle method
  //happens before rendering
  @override
  void initState() {
    //comes from inherit class
    super.initState();

    //calls when rendered app for the first time.
    signOutGoogle();

  }

  void click (){
    //when auth done get the user to do something
    signInWithGoogle().then( (user) => {
      //store the user in the state
      this.user = user,
        //Navigate to the next page
      Navigator.push(context, MaterialPageRoute(builder:  (context)=> SpotsListPage(user)))
    });

  }
  
  Widget googleLoginButton() {
    return RaisedButton(
        onPressed: this.click,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        splashColor: Colors.grey,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(image: AssetImage('assets/google_logo.png'), height: 24,),
              Padding(padding: EdgeInsets.only(left: 10), child: Text("Sign in with Google", style: TextStyle(color: Colors.grey, fontSize: 18),))
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: googleLoginButton()
    );
  }
}

