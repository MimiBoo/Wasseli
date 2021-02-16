import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/Models/placePrediction.dart';
import 'package:wasseli/Widgets/location_item.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/tools/color.dart';

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
                        onChanged: (value) {
                          findPlaces(value);
                        },
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
              (placePredictionList.length > 0)
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListView.separated(
                          itemCount: placePredictionList.length,
                          itemBuilder: (context, index) => LocationItem(placePrediction: placePredictionList[index]),
                          separatorBuilder: (context, index) => Divider(color: dviderColor, thickness: 1),
                          physics: ClampingScrollPhysics(),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      )),
    );
  }

  void findPlaces(String placeName) async {
    var userLocation = Provider.of<AppData>(context, listen: false).userLocation;
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
