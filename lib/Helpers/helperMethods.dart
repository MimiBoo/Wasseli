import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
//
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/Models/address.dart';
import 'package:wasseli/Models/allUsers.dart';
import 'package:wasseli/Models/directionDetails.dart';
import 'package:wasseli/config.dart';

class HelperMethods {
  static Future<String> searchCoordinateAddress(Position position, BuildContext context) async {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$geoKey";

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return "Failed to fetch address";
    }
    placeAddress = response["results"][0]["formatted_address"];
    Address userPickUpAddress = Address();
    userPickUpAddress.longitude = position.longitude;
    userPickUpAddress.latitude = position.latitude;
    userPickUpAddress.placeFormattedAddress = placeAddress;
    Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
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

  static int calculateFares(DirectionDetails directionDetails) {
    var distence = directionDetails.distanceValue;
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

  static void getCurrentOnlineUserInfo() {
    firebaseUser = FirebaseAuth.instance.currentUser;

    String userId = firebaseUser.uid;

    DatabaseReference ref = FirebaseDatabase.instance.reference().child('users').child(userId);

    ref.once().then((DataSnapshot snap) {
      if (snap.value != null) {
        currentUser = Users.fromSnapshot(snap);
      }
    });
  }

  static double createRandomNumber(int number) {
    var random = Random();
    int randNumber = random.nextInt(number);

    return randNumber.toDouble();
  }

  static sendNotificationToDriver(String token, BuildContext context, String rideRequestId) async {
    var destination = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': serverKey,
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': {
            'body': 'DropOff Address, ${destination.placeName}',
            'title': 'New Ride request',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'ride_request_id': rideRequestId,
          },
          'to': token,
        },
      ),
    );
  }
}
