import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/helpers/requestHelper.dart';
import 'package:wasselli/models/address.dart';
import 'package:wasselli/models/placePrediction.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/views/order.dart';
import 'package:wasselli/widgets/progressDialog.dart';

class LocationItem extends StatelessWidget {
  final PlacePrediction placePrediction;

  const LocationItem(this.placePrediction);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getPlaceDetails(placePrediction.placeId, context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .78,
              child: Text(
                placePrediction.mainText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: mainBlack, fontFamily: 'NexaLight', fontSize: 20),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: mainBlack,
              size: 40,
            )
          ],
        ),
      ),
    );
  }

  void getPlaceDetails(String placeId, BuildContext context) async {
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => ProgressDialog('Setting Drop Off...'));
    String placeDetailUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$placesKey";
    var res = await RequestHelper.getRequest(placeDetailUrl);
    Navigator.of(context).pop();
    if (res == 'failed') {
      return;
    }
    if (res['status'] == "OK") {
      Address address = Address();
      address.placeFormattedAddress = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => OrderScreen()), (Route<dynamic> route) => false);
    }
  }
}
