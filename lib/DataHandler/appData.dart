import 'package:flutter/material.dart';
import 'package:wasseli/Models/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation;

  void updatepickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}
