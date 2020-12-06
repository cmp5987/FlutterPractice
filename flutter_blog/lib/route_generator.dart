import 'package:flutter/material.dart';
import 'package:flutter_blog/screens/loginPage.dart';
import 'package:flutter_blog/screens/mainParent.dart';
import 'package:flutter_blog/screens/modifySpotPage.dart';
import 'package:flutter_blog/screens/spotDetailsPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/mainTabs':
        return MaterialPageRoute(builder: (_) => MainParent(args));
      /* Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => SecondPage(
              data: args,
            ),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
        (

       */
      case '/modifySpot':
        return MaterialPageRoute(builder: (_) => ModifySpotPage(args));
      case '/spotDetails':
        return MaterialPageRoute(builder: (_) => SpotDetailsPage(args));
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}