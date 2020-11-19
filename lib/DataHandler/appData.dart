import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasseli/Models/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;
  LatLng _userLocation;

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
}
