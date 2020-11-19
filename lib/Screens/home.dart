import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/helperMethods.dart';
import 'package:wasseli/Screens/search.dart';
import 'package:wasseli/Widgets/customDrawer.dart';
import 'package:wasseli/Widgets/divder.dart';
import 'package:wasseli/Widgets/progressDialog.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLinesSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  Position currentPostion;

  void locatePostion() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPostion = position;

    LatLng latLngPostion = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPostion, zoom: 18);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await HelperMethods.searchCoordinateAddress(position, context);
    print('ADDRESS: $address');
  }

  static final CameraPosition _ouargla = CameraPosition(
    target: LatLng(31.9527, 5.3335),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scafoldKey,
        drawer: CustomDrawer(),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: polyLinesSet,
              markers: markerSet,
              circles: circleSet,
              initialCameraPosition: _ouargla,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController.complete(controller);
                newGoogleMapController = controller;

                locatePostion();
              },
            ),

            //HamburgerButton for Drawer
            Positioned(
              top: 25,
              left: 25,
              child: GestureDetector(
                onTap: () {
                  _scafoldKey.currentState.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 6,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 30,
                    ),
                    radius: 22,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text(
                        'Hi there,',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Where to?',
                        style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.pushNamed(context, SearchScreen.idScreen);

                          if (res == 'obtainDirection') {
                            await getPlaceDirection();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 20,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.black),
                                SizedBox(width: 10),
                                Text('Search Drop Off'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey[400]),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AppData>(context).pickUpLocation != null ? Provider.of<AppData>(context).pickUpLocation.placeName : "Add Home",
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your living home address',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      DividerWidget(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.work, color: Colors.grey[400]),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add Work'),
                              SizedBox(height: 4),
                              Text(
                                'Your office address',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(context: context, builder: (BuildContext context) => ProgressDialog('please wait.'));

    var details = await HelperMethods.obtainDirectionsDetails(pickUpLatLng, dropOffLatLng);
    Navigator.pop(context);

    //print("ENCODED POINTS: ${details.encodedPoints}");

    PolylinePoints points = PolylinePoints();
    List<PointLatLng> decodedPolyLineResult = points.decodePolyline(details.encodedPoints);
    polyLinesSet.clear();
    pLineCoordinates.clear();
    if (decodedPolyLineResult.isNotEmpty) {
      decodedPolyLineResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      polyLinesSet.clear();
      Polyline polyline = Polyline(
        polylineId: PolylineId('route'),
        color: Colors.black,
        width: 5,
        jointType: JointType.round,
        points: pLineCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLinesSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: dropOffLatLng,
        northeast: pickUpLatLng,
      );
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
      );
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));

    Marker pickUpMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: "YOU", snippet: initialPos.placeName),
      position: pickUpLatLng,
      markerId: MarkerId('Me'),
    );
    Marker dropOffMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: "DESTINATION", snippet: finalPos.placeName),
      position: dropOffLatLng,
      markerId: MarkerId('Destination'),
    );
    Circle pickUpCircle = Circle(
      fillColor: Colors.black,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.grey,
      circleId: CircleId('Me'),
    );
    Circle dropOffCircle = Circle(
      fillColor: Colors.black,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.grey,
      circleId: CircleId('Destination'),
    );

    setState(() {
      markerSet.add(pickUpMarker);
      markerSet.add(dropOffMarker);
      circleSet.add(pickUpCircle);
      circleSet.add(dropOffCircle);
    });
  }
}
