import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/views/front_page.dart';
import 'package:wasselli/views/home.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: EasyLocalization(
        supportedLocales: [
          Locale('ar', 'DZ'),
          Locale('en', 'US'),
        ],
        child: MyApp(),
        path: 'assets/languages',
        startLocale: Locale('en', 'US'),
      ),
    ),
  );
}

DatabaseReference userRef = FirebaseDatabase().reference().child('users');
DatabaseReference driverRef = FirebaseDatabase().reference().child('drivers');
DatabaseReference requestRef = FirebaseDatabase.instance.reference().child('rides').push();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    isLatin = context.locale.languageCode == "en";
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Wasseli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: currentFirebaseUser == null ? FrontPage() : HomeScreen(),
    );
  }
}
