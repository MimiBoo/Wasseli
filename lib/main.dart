import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/views/front_page.dart';
import 'package:wasseli/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentFirebaseUser = await getCurrentUser();
  runApp(ChangeNotifierProvider(
    create: (context) => AppData(),
    child: MyApp(),
  ));
}

Future<User> getCurrentUser() {
  final completer = Completer<User>();
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    completer.complete(user);
  });

  return completer.future;
}

DatabaseReference userRef = FirebaseDatabase().reference().child('users');
DatabaseReference driverRef = FirebaseDatabase().reference().child('drivers');
DatabaseReference requestRef = FirebaseDatabase.instance.reference().child('rides').push();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    //
    return MaterialApp(
      title: 'Wasseli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Brand-Regular',
      ),
      home: currentFirebaseUser == null ? FrontPage() : HomeScreen(),
    );
  }
}

//FirebaseAuth.instance.currentUser == null ? FrontPage() : HomeScreen(),
