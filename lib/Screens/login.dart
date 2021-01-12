import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:wasseli/Screens/home.dart';
import 'package:wasseli/Screens/register.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/localization/language.dart';
import 'package:wasseli/localization/localization.dart';
import 'package:wasseli/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  _changeLanguage(BuildContext context, Language language) {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, 'US');
        break;
      case 'ar':
        _temp = Locale(language.languageCode, 'DZ');
        break;
      default:
        _temp = Locale(language.languageCode, 'DZ');
    }

    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    var lang = DemoLocalization.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          lang.getTranslatedValue('login_title'),
          style: TextStyle(fontSize: 24, fontFamily: 'Brand-Bold', color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: DropdownButton(
              underline: SizedBox(width: 0),
              icon: Icon(
                Icons.language,
                color: Colors.black,
              ),
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (lang) => DropdownMenuItem<Language>(
                      value: lang,
                      child: Row(
                        children: [
                          Text(lang.flag),
                          Text(lang.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (Language language) {
                _changeLanguage(context, language);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image(
              image: AssetImage('assets/images/logo.png'),
              height: 250,
              width: 390,
              alignment: Alignment.center,
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 1),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: lang.getTranslatedValue('login_email'),
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 1),
                  TextField(
                    controller: passwordCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: lang.getTranslatedValue('login_password'),
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 15),
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          lang.getTranslatedValue('login_button'),
                          style: TextStyle(
                            fontFamily: 'Brand-Bold',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if (!emailCtrl.text.contains('@')) {
                        displayToatMessage(
                          'Email address not valid',
                          context,
                        );
                      } else if (passwordCtrl.text.length <= 6) {
                        displayToatMessage(
                          'Password must be at least 6 characters long',
                          context,
                        );
                      } else {
                        loginAndAuthenticateUser(context);
                      }
                    },
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.idScreen, (route) => false);
              },
              child: Text(lang.getTranslatedValue('no_account_register')),
            ),
          ],
        ),
      ),
    );
  }

  void loginAndAuthenticateUser(BuildContext context) async {
    var lang = DemoLocalization.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(lang.getTranslatedValue('wait_auth'));
      },
    );
    final User user = (await _firebaseAuth
            .signInWithEmailAndPassword(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    )
            .catchError(
      (err) {
        Navigator.pop(context);
        displayToatMessage("Error: " + err.toString(), context);
      },
    ))
        .user;

    if (user != null) {
      userRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          currentFirebaseUser = user;
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
          displayToatMessage('Logged In', context);
        } else {
          _firebaseAuth.signOut();
          Navigator.pop(context);
          displayToatMessage('No record exists for this user, Please create new account', context);
        }
      });
    } else {
      //Error occured
      Navigator.pop(context);
      displayToatMessage("Error: Something went wrong.", context);
    }
  }
}
