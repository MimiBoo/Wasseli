import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/localization/localization.dart';
import 'package:wasseli/views/front_page.dart';
import 'package:wasseli/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(ChangeNotifierProvider(
    create: (context) => AppData(),
    child: MyApp(),
  ));
}

DatabaseReference userRef = FirebaseDatabase().reference().child('users');
DatabaseReference driverRef = FirebaseDatabase().reference().child('drivers');
DatabaseReference requestRef = FirebaseDatabase.instance.reference().child('Ride Request').push();

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _temp = prefs.getString('languageCode');
    Locale _tempLang;
    switch (_temp) {
      case 'en':
        _tempLang = Locale(_temp, 'US');
        break;
      case 'ar':
        _tempLang = Locale(_temp, 'DZ');
        break;
      default:
        _tempLang = Locale(_temp, 'DZ');
    }
    MyApp.setLocale(context, _tempLang);
  }

  //
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  //
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
      locale: _locale,
      localizationsDelegates: [
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'DZ'),
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      //onGenerateRoute: CustomRouter.allRoutes,
      //initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : HomeScreen.idScreen,
      home: FirebaseAuth.instance.currentUser == null ? FrontPage() : HomeScreen(),
    );
  }
}
