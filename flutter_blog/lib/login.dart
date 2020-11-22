import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/myHomePage.dart';
import 'auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: Text("Blog App")),
          body: Body()
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
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage(user)))
    });

  }
  
  Widget googleLoginButton() {
    return OutlineButton(
        onPressed: this.click,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        splashColor: Colors.grey,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(image: AssetImage('assets/google_logo.png'), height: 35,),
              Padding(padding: EdgeInsets.only(left: 10), child: Text("Sign in with Google", style: TextStyle(color: Colors.grey, fontSize: 25),))
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

