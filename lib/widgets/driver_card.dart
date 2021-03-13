import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/helpers/helperMethods.dart';
import 'package:wasselli/models/driver.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/views/search.dart';

class DriverCard extends StatefulWidget {
  final Driver driver;

  DriverCard(this.driver);

  @override
  _DriverCardState createState() => _DriverCardState();
}

class _DriverCardState extends State<DriverCard> {
  String distance = '';

  void getDistance() async {
    var pickUpLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    var dropOffLatLng = LatLng(widget.driver.latitude, widget.driver.longitude);
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
    return GestureDetector(
      onTap: () {
        Provider.of<AppData>(context, listen: false).selectDriver(widget.driver);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
        // print("Clicked: ${widget.driver.key}");
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: mainBlack,
              child: Text(
                widget.driver.rating.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.driver.firstName} ${widget.driver.lastName}",
                      style: TextStyle(fontSize: 26, fontFamily: "NexaBold"),
                    ),
                    Text(
                      "($distance)",
                      style: TextStyle(fontSize: 16, fontFamily: "MS"),
                    ),
                  ],
                ),
                Text(
                  "${widget.driver.carInfo['model']}|${widget.driver.carInfo['ID']}",
                  style: TextStyle(fontSize: 16, fontFamily: "MS", color: Colors.grey),
                ),
              ],
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
}
