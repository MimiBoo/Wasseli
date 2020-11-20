import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Screens/home.dart';
import 'package:wasseli/Screens/login.dart';
import 'package:wasseli/Screens/profile.dart';
import 'package:wasseli/Screens/register.dart';
import 'package:wasseli/Screens/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef = FirebaseDatabase().reference().child('users');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Wasseli',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Brand-Regular',
        ),
        initialRoute: LoginScreen.idScreen,
        routes: {
          RegisterScreen.idScreen: (context) => RegisterScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          HomeScreen.idScreen: (context) => HomeScreen(),
          SearchScreen.idScreen: (context) => SearchScreen(),
          ProfilePage.idScreen: (context) => ProfilePage(),
        },
      ),
    );
  }
}
