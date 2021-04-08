import 'package:flutter/material.dart';
import 'package:wasselli/Widgets/button.dart';
import 'package:wasselli/tools/background.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';
import 'package:wasselli/views/otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _ctrl = TextEditingController();

  void authenticate() async {}
  @override
  Widget build(BuildContext context) {
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
                child: Icon(
                  Wasseli.close,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            Positioned(
              left: 30,
              right: 30,
              top: MediaQuery.of(context).size.height / 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Autenticate',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaBold', fontSize: 40),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      Container(
                        width: 333,
                        height: 70,
                        child: TextField(
                          controller: _ctrl,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: mainBlack),
                          maxLength: 10,
                          decoration: InputDecoration(
                            counterText: '',
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                '+213',
                                style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: hintColor),
                              ),
                            ),
                            fillColor: Colors.white.withAlpha(200),
                            filled: true,
                            hintText: 'Phone Number',
                            contentPadding: EdgeInsets.only(top: 40),
                            hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      CustomButton(
                        title: 'Next',
                        color: mainTeal,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(_ctrl.text.replaceFirst(RegExp(r'^0+'), ""))));
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
}
