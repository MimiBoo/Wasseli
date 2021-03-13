import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/helpers/helperMethods.dart';
import 'package:wasselli/models/ride_types.dart';
import 'package:wasselli/tools/color.dart';

class RideTypeTile extends StatefulWidget {
  final RideTypes rideTypes;
  final Function(bool) onTap;

  RideTypeTile({this.rideTypes, this.onTap});

  @override
  _RideTypeTileState createState() => _RideTypeTileState();
}

class _RideTypeTileState extends State<RideTypeTile> {
  String distance = "";

  void getDistance() async {
    var dropOff = Provider.of<AppData>(context, listen: false).userDropOffLocation;

    var pickUpLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    var dropOffLatLng = LatLng(dropOff.latitude, dropOff.longitude);
    var details = await HelperMethods.obtainDirectionsDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      distance = details.distanceText;
    });
  }

  @override
  void initState() {
    super.initState();
    getDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainGrey,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: [
          widget.rideTypes.icon,
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.rideTypes.title,
                style: TextStyle(fontSize: 20, fontFamily: "NexaBold"),
              ),
              Text(
                distance,
                style: TextStyle(fontSize: 14, fontFamily: "NexaLight"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
