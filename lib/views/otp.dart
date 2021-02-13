import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/main.dart';
import 'package:wasseli/tools/background.dart';
import 'package:wasseli/views/home.dart';
import 'package:wasseli/views/register.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen(this.phone);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationCode;
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Color(0xFFECEBEE),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Color(0xFFECEBEE),
    ),
  );
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  GlobalKey<ScaffoldState> _scaffolKey = GlobalKey<ScaffoldState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffolKey,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Verify +213-${widget.phone}',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaBold', fontSize: 20),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: PinPut(
                      fieldsCount: 6,
                      withCursor: true,
                      textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                      eachFieldWidth: 40.0,
                      eachFieldHeight: 55.0,
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: pinPutDecoration,
                      selectedFieldDecoration: pinPutDecoration,
                      followingFieldDecoration: pinPutDecoration,
                      pinAnimationType: PinAnimationType.scale,
                      onSubmit: (pin) async {
                        loginAndAuthenticateUser(pin);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
/*
  void loginAndAuthenticateUser(BuildContext context, String pin) async {
    var lang = DemoLocalization.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(lang.getTranslatedValue('wait_auth'));
      },
    );
    final User user = (await _firebaseAuth
            .signInWithCredential(
      PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: pin),
    )
            .catchError(
      (err) {
        Navigator.pop(context);
        SnackBar(content: Text("Error: " + err.toString()));
      },
    ))
        .user;
    if (user != null) {
      userRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          if (snap.value['phone'] != null && snap.value['first_name'] != null && snap.value['last_name'] != null) {
            currentFirebaseUser = user;
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterScreen(widget.phone)));
          } else {
            currentFirebaseUser = user;
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
            SnackBar(content: Text('Logged In'));
          }
        } else {
          currentFirebaseUser = user;
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterScreen(widget.phone)));
        }
      });
    }
  }*/

  void loginAndAuthenticateUser(String pin) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      AuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: pin);
      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;
      if (user != null) {
        currentFirebaseUser = user;
        var snap = await userRef.child(user.uid).once();
        if (snap.value != null) {
          print(snap.value['first_name']);
          print(snap.value['last_name']);
          print(snap.value['phone']);
          print(user.uid);
          if (snap.value['first_name'] != null && snap.value['last_name'] != null && snap.value['phone'] != null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterScreen(widget.phone)));
          }
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterScreen(widget.phone)));
        }
      } else {
        SnackBar(content: Text('Error'));
      }
    } catch (e) {
      FocusScope.of(context).unfocus();
      _scaffolKey.currentState.showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  void _verifyPhone() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: "+213${widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential result = await _auth.signInWithCredential(credential);
        User user = result.user;

        if (user != null) {
          currentFirebaseUser = user;
          var snap = await userRef.child(user.uid).once();
          if (snap.value != null) {
            print(snap.value['first_name']);
            print(snap.value['last_name']);
            print(snap.value['phone']);
            print(user.uid);
            if (snap.value['first_name'] != null && snap.value['last_name'] != null && snap.value['phone'] != null) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterScreen(widget.phone)));
            }
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterScreen(widget.phone)));
          }
        } else {
          SnackBar(content: Text('Error'));
        }
      },
      verificationFailed: (FirebaseAuthException err) {
        SnackBar(content: Text(err.message));
      },
      codeSent: (String verificationID, int resendToken) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
