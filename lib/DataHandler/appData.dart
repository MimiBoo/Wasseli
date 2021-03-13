import 'package:flutter/cupertino.dart';
import 'package:wasselli/models/address.dart';
import 'package:wasselli/models/driver.dart';

class AppData extends ChangeNotifier {
  Driver _selecteDriver;
  Address userPickUpLocation, userDropOffLocation;

  Driver get selecteDriver => _selecteDriver;

  void selectDriver(Driver driver) {
    _selecteDriver = driver;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updatePickUpLocationAddress(Address pickUpAddress) {
    userPickUpLocation = pickUpAddress;
    notifyListeners();
  }
}
