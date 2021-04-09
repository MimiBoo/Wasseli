import 'package:flutter/material.dart';
import 'package:wasselli/Widgets/button.dart';
import 'package:wasselli/tools/background.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';
import 'package:wasselli/views/otp.dart';
import 'package:easy_localization/easy_localization.dart';

import '../config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _ctrl = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void authenticate() async {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                    'authenticate'.tr(),
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
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: mainBlack),
                          maxLength: 10,
                          decoration: isLatin
                              ? InputDecoration(
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
                                  hintText: 'phone'.tr(),
                                  contentPadding: EdgeInsets.only(top: 40),
                                  hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                )
                              : InputDecoration(
                                  counterText: '',
                                  suffix: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      '+213'.split('+').reversed.join('+'),
                                      style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: hintColor),
                                    ),
                                  ),
                                  fillColor: Colors.white.withAlpha(200),
                                  filled: true,
                                  hintText: 'phone'.tr(),
                                  contentPadding: EdgeInsets.only(top: 40),
                                  hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                ),
                        ),
                      ),
                      SizedBox(height: 18),
                      CustomButton(
                        title: 'next'.tr(),
                        color: mainTeal,
                        onTap: () {
                          if (_ctrl.text.isNotEmpty) {
                            navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => OtpScreen(_ctrl.text.replaceFirst(RegExp(r'^0+'), ""))));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("empty_phone".tr()),
                            ));
                          }
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
