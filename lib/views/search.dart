import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wasseli/Widgets/location_item.dart';
import 'package:wasseli/tools/color.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/close.svg',
              fit: BoxFit.cover,
              color: mainBlack,
              width: 20,
              height: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 46, left: 28, right: 28),
                height: 80,
                decoration: BoxDecoration(color: mainBlack, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SvgPicture.asset(
                        'assets/images/pin.svg',
                        fit: BoxFit.cover,
                        color: Colors.white,
                        width: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Where to deliver?",
                          hintStyle: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 25),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 31),
                child: Divider(
                  color: dviderColor,
                  thickness: 1,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    children: [
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                      LocationItem(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
