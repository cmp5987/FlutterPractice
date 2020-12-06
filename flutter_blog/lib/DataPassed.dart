import 'package:firebase_auth/firebase_auth.dart';

import 'spot.dart';

class DataPassed {
  FirebaseUser user;
  Spot spot;
  Function callback;
  DataPassed({this.user, this.spot, this.callback});
}