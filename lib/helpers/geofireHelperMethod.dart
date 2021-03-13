import 'package:wasselli/models/driver.dart';

class GeoFireHelper {
  static List<Driver> nearByDriversList = [];

  static void removeDriverFromList(String key) {
    int index = nearByDriversList.indexWhere((element) => element.key == key);
    nearByDriversList.removeAt(index);
  }

  static void updateDriverNearbyLocation(Driver driver) {
    int index = nearByDriversList.indexWhere((element) => element.key == driver.key);
    nearByDriversList[index].longitude = driver.longitude;
    nearByDriversList[index].latitude = driver.latitude;
  }
}
