import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/Models/address.dart';
import 'package:wasseli/Models/placePrediction.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/configMaps.dart';

class PredictionsTile extends StatelessWidget {
  final PlacePrediction placePrediction;
  PredictionsTile({Key key, this.placePrediction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceAddressDetails(placePrediction.placeId, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placePrediction.mainText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        placePrediction.secondaryText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(context: context, builder: (BuildContext context) => ProgressDialog('Setting drop off, please wait.'));
    String placeDetailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$placesKey';

    var res = await RequestHelper.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if (res == 'failed') {
      return;
    }
    if (res['status'] == "OK") {
      Address address = Address();
      address.placeName = res['result']['name'];
      address.placeId = placeId;
      address.latitude = res['result']['geometry']['location']['lat'];
      address.longitude = res['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);

      //print("DROP OF: ${address.placeName}");

      Navigator.pop(context, "obtainDirection");
    }
  }
}
