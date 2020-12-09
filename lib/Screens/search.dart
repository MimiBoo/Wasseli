import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/Models/placePrediction.dart';
import 'package:wasseli/Widgets/divder.dart';
import 'package:wasseli/Widgets/predictions.dart';
import 'package:wasseli/config.dart';

class SearchScreen extends StatefulWidget {
  static const String idScreen = 'search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _pickUpCtrl = TextEditingController();
  TextEditingController _dropOffCtrl = TextEditingController();

  List<PlacePrediction> placePredictionList = [];
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
                                onChanged: (value) {
                                  findPlace(value);
                                },
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
            //tile for display predictions

            (placePredictionList.length > 0)
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return PredictionsTile(
                          placePrediction: placePredictionList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    var userLocation = Provider.of<AppData>(context, listen: false).userLocation;
    if (placeName.isNotEmpty) {
      String autoCompleteUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&location=${userLocation.latitude}, ${userLocation.longitude}&radius=100&components=country:dz&key=$placesKey&sessiontoken=1234567890';

      var res = await RequestHelper.getRequest(autoCompleteUrl);

      if (res == 'faied') {
        return;
      }
      //print("RESPONSE: $res");
      if (res['status'] == "OK") {
        var predictions = res['predictions'];

        var placesList = (predictions as List).map((e) => PlacePrediction.fromJson(e)).toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}
