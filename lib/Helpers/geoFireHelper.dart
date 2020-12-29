import 'package:wasseli/Models/nearbyDrivers.dart';

class GeoFireHelper {
  static List<NearbyDrivers> nearbyDriversList = [];

  static void removeDriverFromList(String key) {
    int index = nearbyDriversList.indexWhere((element) => element.key == key);
    nearbyDriversList.removeAt(index);
  }

  static void updateDriverNearbyLocation(NearbyDrivers driver) {
    int index = nearbyDriversList.indexWhere((element) => element.key == driver.key);
    print(index);
    nearbyDriversList[index].longitude = driver.longitude;
    nearbyDriversList[index].latitude = driver.latitude;
  }
}
