import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';

class SearchScreen extends StatefulWidget {
  static const String idScreen = 'search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _pickUpCtrl = TextEditingController();
  TextEditingController _dropOffCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName;
    _pickUpCtrl.text = placeAddress;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 215,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 6,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios),
                        ),
                        Center(
                          child: Text(
                            'Set Drop Off',
                            style: TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Image.asset('assets/images/pickicon.png', height: 20, width: 20),
                        SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: TextField(
                                controller: _pickUpCtrl,
                                decoration: InputDecoration(
                                  hintText: 'PickUp Location',
                                  fillColor: Colors.grey[400],
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11, top: 8, bottom: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Image.asset('assets/images/desticon.png', height: 20, width: 20),
                        SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: TextField(
                                controller: _dropOffCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Drop Off Location',
                                  fillColor: Colors.grey[400],
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11, top: 8, bottom: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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