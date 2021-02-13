import 'package:flutter/material.dart' show BorderRadius, BorderSide, BoxDecoration, BuildContext, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, Form, InputDecoration, MaterialPageRoute, Navigator, OutlineInputBorder, Positioned, SafeArea, Scaffold, SizedBox, Stack, State, StatefulWidget, Text, TextAlign, TextFormField, TextInputType, TextStyle, Widget;
import 'package:wasseli/Widgets/button.dart';
import 'package:wasseli/tools/background.dart';
import 'package:wasseli/tools/color.dart';


class CarInfo extends StatefulWidget {
  @override
  _CarInfoState createState() => _CarInfoState();
}

class _CarInfoState extends State<CarInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            BackgroundBlur(),
            Positioned(
              left: 30,
              right: 30,
              bottom: 145,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black26,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Info',
                      style: TextStyle(color: Colors.white, fontFamily: 'NexaBold', fontSize: 60),
                    ),
                    SizedBox(height: 30),
                    Form(
                      child: Column(
                        children: [
                          Container(
                            width: 333,
                            height: 70,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: mainBlack),
                              decoration: InputDecoration(
                                fillColor: Colors.white.withAlpha(200),
                                filled: true,
                                hintText: 'Car Model',
                                contentPadding: EdgeInsets.only(top: 40),
                                hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          Container(
                            width: 333,
                            height: 70,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: mainBlack),
                              decoration: InputDecoration(
                                fillColor: Colors.white.withAlpha(200),
                                filled: true,
                                hintText: 'Color',
                                contentPadding: EdgeInsets.only(top: 40),
                                hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          Container(
                            width: 333,
                            height: 70,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontFamily: 'NexaLight', fontSize: 16, color: mainBlack),
                              decoration: InputDecoration(
                                fillColor: Colors.white.withAlpha(200),
                                filled: true,
                                hintText: 'Car ID',
                                contentPadding: EdgeInsets.only(top: 40),
                                hintStyle: TextStyle(fontFamily: 'NexaLight', fontSize: 25, color: hintColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          CustomButton(
                            title: 'Add Car Info',
                            color: mainTeal,
                            onTap: () {
                              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                            },
                            titleColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
