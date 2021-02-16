import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/helperMethods.dart';
import 'package:wasseli/Widgets/button.dart';
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

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

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

  bool isOrder = false;
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
              polylines: polyLineSet,
              markers: markerSet,
              circles: circleSet,
              initialCameraPosition: _algeria,
              onMapCreated: (GoogleMapController controller) {
                if (_googleMapController == null) _googleMapController.complete(controller);
                newGoogleMapController = controller;
                locatePosition();
              },
            ),
            !isOrder
                ? GestureDetector(
                    onTap: () async {
                      var res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
                      if (res == "obtainDirection") {
                        setState(() {
                          isOrder = true;
                        });
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
                  )
                : RaisedButton(
                    onPressed: () {
                      setState(() {
                        isOrder = false;
                      });
                    },
                  ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: mainTeal,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/truck.png',
                              height: 70,
                              width: 80,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mini Truck',
                                  style: TextStyle(fontSize: 18, fontFamily: 'NexaBold'),
                                ),
                                Text(
                                  '10 Km',
                                  style: TextStyle(fontSize: 16, fontFamily: 'NexaBold', color: Colors.black45),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.moneyCheckAlt,
                            size: 18,
                            color: mainBlack,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Cash',
                            style: TextStyle(fontSize: 16, fontFamily: 'NexaBold', color: mainBlack),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CustomButton(
                        color: mainTeal,
                        title: 'Request',
                        onTap: () {
                          print("clicked");
                        },
                        titleColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: !isOrder
            ? Container(
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
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: !isOrder
            ? BottomAppBar(
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
              )
            : null,
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

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePoints = polylinePoints.decodePolyline(details.encodedPoints);
    polyLineSet.clear();
    pLineCoordinates.clear();
    if (decodedPolyLinePoints.isNotEmpty) {
      decodedPolyLinePoints.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    Marker pickUpMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: 'You', snippet: 'Your current location'),
      position: pickUpLatLng,
      markerId: MarkerId('YOU'),
    );
    Marker dropOffMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: 'Drop Off', snippet: 'Your destination'),
      position: dropOffLatLng,
      markerId: MarkerId('DROPOOF'),
    );

    Circle pickUpCirle = Circle(
      fillColor: mainTeal,
      center: pickUpLatLng,
      radius: 8,
      strokeWidth: 4,
      strokeColor: Colors.grey,
      circleId: CircleId('PickUp'),
    );
    Circle dropOffCirle = Circle(
      fillColor: mainTeal,
      center: dropOffLatLng,
      radius: 8,
      strokeWidth: 4,
      strokeColor: Colors.grey,
      circleId: CircleId('DropOff'),
    );

    setState(() {
      polyLineSet.clear();
      Polyline polyline = Polyline(
        polylineId: PolylineId('route'),
        color: mainTeal,
        width: 5,
        jointType: JointType.round,
        points: pLineCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polyLineSet.add(polyline);
      circleSet.add(pickUpCirle);
      circleSet.add(dropOffCirle);
      markerSet.add(pickUpMarker);
      markerSet.add(dropOffMarker);
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

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }
}
