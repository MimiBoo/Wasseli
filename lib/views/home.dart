import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/helperMethods.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/tools/color.dart';
import 'package:wasseli/views/profile.dart';
import 'package:wasseli/views/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;

  Position currentPosition;
  //var geoLocator = Geolocator();

  static final CameraPosition _algeria = CameraPosition(
    target: LatLng(28.0339, 1.6596),
    zoom: 5,
  );

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 18);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await HelperMethods.searchCoordinateAddress(position, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              compassEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: _algeria,
              onMapCreated: (GoogleMapController controller) {
                if (_googleMapController == null) _googleMapController.complete(controller);
                newGoogleMapController = controller;
                locatePosition();
              },
            ),
            GestureDetector(
              onTap: () async {
                var res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
                if (res == "obtainDirection") {
                  await getPlaceDirection();
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 46, left: 28, right: 28),
                height: 80,
                decoration: BoxDecoration(color: mainBlack, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SvgPicture.asset(
                        'assets/images/pin.svg',
                        fit: BoxFit.cover,
                        color: Colors.white,
                        width: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Where to deliver?',
                      style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: mainTeal,
            onPressed: () {
              locatePosition();
            },
            child: SvgPicture.asset(
              'assets/images/gps.svg',
              fit: BoxFit.cover,
              color: Colors.white,
              width: 40,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            color: mainBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/menu.svg',
                      fit: BoxFit.cover,
                      color: Colors.white,
                      width: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/profile.svg',
                      fit: BoxFit.cover,
                      color: Colors.white,
                      width: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = Provider.of<AppData>(context, listen: false).userPickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).userDropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => ProgressDialog('Please wait...'));

    var details = await HelperMethods.obtainDirectionsDetails(pickUpLatLng, dropOffLatLng);

    Navigator.of(context).pop();

    print("ENCODED POINTS: ${details.encodedPoints}");
  }
}
