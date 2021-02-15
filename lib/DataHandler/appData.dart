import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasseli/Models/address.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/main.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;
  Address userPickUpLocation, userDropOffLocation;
  LatLng _userLocation;

  bool isLoggedIn;

  String phoneNumber, emailAddress, fullName;

  LatLng get userLocation => _userLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    userPickUpLocation = pickUpAddress;
    //_userLocation = LatLng(pickUpAddress.latitude, pickUpAddress.longitude);
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;

    notifyListeners();
  }

  void updateUserData() {
    var user = currentFirebaseUser;
    if (user != null) {
      userRef.child(user.uid).once().then((DataSnapshot snap) {
        phoneNumber = snap.value['phone'];
        fullName = snap.value['name'];
        emailAddress = snap.value['email'];
      });
    }
  }
}
