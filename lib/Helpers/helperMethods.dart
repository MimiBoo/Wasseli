import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/Models/address.dart';
import 'package:wasseli/configMaps.dart';

class HelperMethods {
  static Future<String> searchCoordinateAddress(Position position, BuildContext context) async {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$geoKey";

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response["results"][0]["formatted_address"];

      print("ADDRESS: $placeAddress");
      Address userPickUpAddress = Address();

      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatepickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }
}
