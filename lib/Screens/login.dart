import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/helperMethods.dart';
import 'package:wasseli/Screens/home.dart';
import 'package:wasseli/Screens/register.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 45),
            Image(
              image: AssetImage('assets/images/logo.png'),
              height: 250,
              width: 390,
              alignment: Alignment.center,
            ),
            SizedBox(height: 1),
            Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: 'Brand-Bold'),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 1),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
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
                      hintText: 'Password',
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
                          'Login',
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
                      } else if (passwordCtrl.text.length < 7) {
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
              child: Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog('Authenticating, Please wait...');
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
      //save user info to database
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
      displayToatMessage('Logged In', context);
    } else {
      //Error occured
      Navigator.pop(context);
      displayToatMessage("Error: Something went wrong.", context);
    }
  }
}
