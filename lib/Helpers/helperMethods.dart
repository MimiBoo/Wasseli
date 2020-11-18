import 'package:geolocator/geolocator.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/configMaps.dart';

class HelperMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$geoKey";

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response["results"][0]["formatted_address"];
    }

    return placeAddress;
  }
}
