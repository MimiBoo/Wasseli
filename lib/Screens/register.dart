import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:wasseli/Screens/login.dart';
import 'package:wasseli/Screens/home.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/localization/language.dart';
import 'package:wasseli/localization/localization.dart';
import 'package:wasseli/main.dart';

class RegisterScreen extends StatelessWidget {
  static const String idScreen = 'register';

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
          lang.getTranslatedValue('register_title'),
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
                    controller: nameCtrl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: lang.getTranslatedValue('register_full_name'),
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 1),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: lang.getTranslatedValue('register_email'),
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 1),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: lang.getTranslatedValue('register_phone'),
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
                      hintText: lang.getTranslatedValue('register_password'),
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
                          lang.getTranslatedValue('register_button'),
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
                      if (nameCtrl.text.length < 4) {
                        displayToatMessage(
                          'Name must be at least 3 characters long',
                          context,
                        );
                      } else if (!emailCtrl.text.contains('@')) {
                        displayToatMessage(
                          'Email address not valid',
                          context,
                        );
                      } else if (phoneCtrl.text.isEmpty) {
                        displayToatMessage(
                          'Phone number is requird',
                          context,
                        );
                      } else if (passwordCtrl.text.length < 7) {
                        displayToatMessage(
                          'Password must be at least 6 characters long',
                          context,
                        );
                      } else {
                        registerNewUser(context);
                      }
                    },
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              },
              child: Text(lang.getTranslatedValue('have_account_login')),
            ),
          ],
        ),
      ),
    );
  }

  void registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog('Registering, Please wait...');
      },
    );
    final User user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
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
    //user created
    if (user != null) {
      //save user info to database

      Map userDataMap = {
        'name': nameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
      };

      userRef.child(user.uid).set(userDataMap);
      currentFirebaseUser = user;
      displayToatMessage('${currentFirebaseUser.uid}', context);

      Navigator.pushNamed(context, HomeScreen.idScreen);
    } else {
      //Error occured
      Navigator.pop(context);
      displayToatMessage("Error: New user has not been created", context);
    }
  }
}

displayToatMessage(String message, BuildContext context) {
  Fluttertoast.showToast(
    msg: message,
  );
}
