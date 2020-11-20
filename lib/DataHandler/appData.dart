import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasseli/Helpers/helperMethods.dart';
import 'package:wasseli/Models/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;
  LatLng _userLocation;

  bool isLoggedIn;

  String phoneNumber, emailAddress, fullName;

  LatLng get userLocation => _userLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    _userLocation = LatLng(pickUpAddress.latitude, pickUpAddress.longitude);
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;

    notifyListeners();
  }

  void updateUserData(String phone, String email, String name) {
    phoneNumber = phone;
    fullName = name;
    emailAddress = email;

    notifyListeners();
  }

  void checkUserAuthState() async {
    await HelperMethods.getUserLoggedInSharedPrefernce().then((value) {
      isLoggedIn = value;
    });
    notifyListeners();
  }
}
