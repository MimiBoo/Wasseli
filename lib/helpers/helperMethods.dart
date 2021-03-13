import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/helpers/requestHelper.dart';
import 'package:wasselli/main.dart';
import 'package:wasselli/models/address.dart';
import 'package:wasselli/models/directionDetails.dart';
import 'package:wasselli/models/users.dart';

class HelperMethods {
  static Future<Address> searchCoordinateAddress(Position position, BuildContext context) async {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$geoKey";

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      throw ("Failed to fetch address");
    }
    placeAddress = response["results"][0]["formatted_address"];
    Address userPickUpAddress = Address();
    userPickUpAddress.longitude = position.longitude;
    userPickUpAddress.latitude = position.latitude;
    userPickUpAddress.placeFormattedAddress = placeAddress;
    return userPickUpAddress;
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

  static int calculateFares(DirectionDetails directionDetails) {
    var distence = directionDetails.durationValue;
    if (distence <= 10000) {
      return 500;
    } else if (distence <= 20000 && distence >= 10000) {
      return 1000;
    } else {
      double timeTravelfare = (directionDetails.durationValue / 60) * 0.2;
      double distanceTravelfare = (directionDetails.distanceValue / 1000) * 0.2;
      double totalPrice = timeTravelfare + distanceTravelfare;

      double totalLocal = totalPrice * 131.90;

      return totalLocal.truncate();
    }
  }

  static void getCurrentOnlineUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String userId = currentFirebaseUser.uid;
    var snap = await userRef.child(userId).once();

    if (snap.value != null) {
      currentUserInfo = Users.fromSnapshot(snap);
    }
  }
}
