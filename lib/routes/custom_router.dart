import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wasseli/Screens/home.dart';
import 'package:wasseli/Screens/login.dart';
import 'package:wasseli/Screens/profile.dart';
import 'package:wasseli/Screens/register.dart';
import 'package:wasseli/Screens/search.dart';

class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.idScreen:
        return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());
      case LoginScreen.idScreen:
        return MaterialPageRoute(builder: (BuildContext context) => LoginScreen());
      case RegisterScreen.idScreen:
        return MaterialPageRoute(builder: (BuildContext context) => RegisterScreen());
      case SearchScreen.idScreen:
        return MaterialPageRoute(builder: (BuildContext context) => SearchScreen());
      case ProfilePage.idScreen:
        return MaterialPageRoute(builder: (BuildContext context) => ProfilePage());
    }
    return MaterialPageRoute(builder: (BuildContext context) => LoginScreen());
  }
}
