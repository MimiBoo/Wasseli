import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/requestHelper.dart';
import 'package:wasseli/Models/address.dart';
import 'package:wasseli/Models/placePrediction.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/tools/color.dart';

class LocationItem extends StatelessWidget {
  final PlacePrediction placePrediction;
  LocationItem({Key key, this.placePrediction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getPlaceDetails(placePrediction.placeId, context);
      },
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/pin.svg',
                  fit: BoxFit.cover,
                  color: mainTeal,
                  width: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Text(
                    placePrediction.mainText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: mainBlack, fontFamily: 'NexaLight', fontSize: 20),
                  ),
                ),
              ],
            ),
            IconButton(
                icon: RotationTransition(
                  turns: new AlwaysStoppedAnimation(180 / 360),
                  child: SvgPicture.asset(
                    'assets/images/previous.svg',
                    fit: BoxFit.cover,
                    color: mainBlack,
                    width: 30,
                  ),
                ),
                onPressed: null)
          ],
        ),
      ),
    );
  }

  void getPlaceDetails(String placeId, BuildContext context) async {
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => ProgressDialog('Setting Drop Off...'));
    //print(placeId);
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
      //print("DROP OFF LOCATION: ${address.latitude}");
      Navigator.of(context).pop("obtainDirection");
    }
  }
}
