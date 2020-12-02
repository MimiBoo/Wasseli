import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/Models/address.dart';
import 'package:wasseli/Models/directionDetails.dart';
import 'package:wasseli/configMaps.dart';

class HelperMethods {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";

  static Future<String> searchCoordinateAddress(Position position, BuildContext context) async {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$geoKey";

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response["results"][0]["formatted_address"];

      print("ADDRESS: $placeAddress");
      Address userPickUpAddress = Address();

      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> obtainDirectionsDetails(LatLng initialPos, LatLng finalPos) async {
    String directionsUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPos.latitude},${initialPos.longitude}&destination=${finalPos.latitude},${finalPos.longitude}&key=$directionKey';

    var res = await RequestHelper.getRequest(directionsUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res['routes'][0]['overview_polyline']['points'];
    directionDetails.distanceText = res['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = res['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.durationText = res['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = res['routes'][0]['legs'][0]['duration']['value'];

    return directionDetails;
  }

  static Future<bool> saveUserLoggedInSharedPrefernce(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> getUserLoggedInSharedPrefernce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get(sharedPreferenceUserLoggedInKey);
  }

  static int calculateFares(DirectionDetails directionDetails) {
    double timeTravelfare = (directionDetails.durationValue / 60) * 0.2;
    double distanceTravelfare = (directionDetails.distanceValue / 1000) * 0.2;

    double totalPrice = timeTravelfare + distanceTravelfare;

    double totalLocal = totalPrice * 129.24;

    return totalLocal.truncate();
  }
}
