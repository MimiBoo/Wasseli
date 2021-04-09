import 'package:flutter/material.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/helpers/requestHelper.dart';
import 'package:wasselli/models/placePrediction.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';
import 'package:wasselli/widgets/location_item.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PlacePrediction> placePredictionList = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Wasseli.close,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 28),
                  height: 80,
                  decoration: BoxDecoration(color: mainBlack, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Wasseli.pin,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextField(
                          onChanged: (value) {
                            findPlaces(value);
                          },
                          decoration: InputDecoration(
                            hintText: "where".tr(),
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
              ],
            ),
            (placePredictionList.length > 0)
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        itemCount: placePredictionList.length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: LocationItem(placePredictionList[index]),
                        ),
                        physics: ClampingScrollPhysics(),
                      ),
                    ),
                  )
                : Expanded(child: Center(child: Text('no_place_found'.tr()))),
          ],
        ),
      ),
    );
  }

  void findPlaces(String placeName) async {
    var userLocation = currentPosition;
    if (placeName.length >= 1) {
      String autoCompleteUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&location=${userLocation.latitude},${userLocation.longitude}&radius=100&components=country:dz&key=$placesKey&sessiontoken=1234567890';
      var res = await RequestHelper.getRequest(autoCompleteUrl);

      if (res == 'failed') {
        return;
      }
      //print("PLACES: $res");

      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List).map((e) => PlacePrediction.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}
