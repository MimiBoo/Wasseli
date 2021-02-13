import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wasseli/Widgets/button.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/localization/localization.dart';
import 'package:wasseli/main.dart';
import 'package:wasseli/tools/background.dart';
import 'package:wasseli/tools/color.dart';
import 'package:wasseli/views/home.dart';

class RegisterScreen extends StatelessWidget {
  final String phone;
  RegisterScreen(this.phone);
  TextEditingController _firstCtrl = TextEditingController();
  TextEditingController _lastCtrl = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var lang = DemoLocalization.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            BackgroundBlur(),
            Positioned(
              top: 30,
              left: 25,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  'assets/images/close.svg',
                  fit: BoxFit.cover,
                  color: Colors.white,
                  width: 40,
                ),
              ),
            ),
            Positioned(
              left: 30,
              right: 30,
              top: MediaQuery.of(context).size.height / 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaBold', fontSize: 40),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      Container(
                        width: 333,
                        height: 70,
                        child: TextField(
                          controller: _firstCtrl,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: mainBlack),
                          decoration: InputDecoration(
                            fillColor: Colors.white.withAlpha(200),
                            filled: true,
                            hintText: 'First Name',
                            hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Container(
                        width: 333,
                        height: 70,
                        child: TextField(
                          controller: _lastCtrl,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: mainBlack),
                          decoration: InputDecoration(
                            fillColor: Colors.white.withAlpha(200),
                            filled: true,
                            hintText: 'Last Name',
                            hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      CustomButton(
                        title: 'Register',
                        color: mainTeal,
                        onTap: () {
                          registerNewUser(context);
                        },
                        titleColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
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
    Map userDataMap = {
      'first_name': _firstCtrl.text.trim(),
      'last_name': _lastCtrl.text.trim(),
      'phone': '+2130$phone',
    };
    userRef.child(currentFirebaseUser.uid).set(userDataMap);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}
