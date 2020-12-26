import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:wasseli/Screens/login.dart';
import 'package:wasseli/Screens/home.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/main.dart';

class RegisterScreen extends StatelessWidget {
  static const String idScreen = 'register';

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
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
              'Register',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: 'Brand-Bold'),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 1),
                  TextField(
                    controller: nameCtrl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
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
                      hintText: 'Email',
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
                      hintText: 'Phone number',
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
                          'Register',
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
              child: Text('Already have an account? Login here'),
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
