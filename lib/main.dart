import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Screens/home.dart';
import 'package:wasseli/Screens/login.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/localization/localization.dart';
import 'package:wasseli/routes/custom_router.dart';

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
      onGenerateRoute: CustomRouter.allRoutes,
      initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : HomeScreen.idScreen,
    );
  }
}
