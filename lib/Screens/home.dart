import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/geoFireHelper.dart';
import 'package:wasseli/Helpers/helperMethods.dart';
import 'package:wasseli/Models/directionDetails.dart';
import 'package:wasseli/Screens/register.dart';
import 'package:wasseli/Screens/search.dart';
import 'package:wasseli/Widgets/customDrawer.dart';
import 'package:wasseli/Widgets/divder.dart';
import 'package:wasseli/Widgets/noDriversDialog.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/Models/nearbyDrivers.dart';
import 'package:wasseli/config.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  List<LatLng> pLineCoordinates = [];

  Set<Polyline> polyLinesSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  Position currentPostion;

  double rideDetailsHeight = 0;
  double searcHeight = 270;
  double requestHeight = 0;
  double bottomMapPadding = 0;

  DirectionDetails tripDirectionDetails;

  DatabaseReference requestRef;
  DatabaseReference availableRef;

  bool drawerOpen = true;
  bool nearbyDriverKeysLoaded = false;

  BitmapDescriptor customIcon;

  List<NearbyDrivers> availableDrivers;

  void restApp() {
    setState(() {
      drawerOpen = true;
      searcHeight = 270;
      rideDetailsHeight = 0;
      requestHeight = 0;
      bottomMapPadding = 270;

      polyLinesSet.clear();
      markerSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();
    });

    locatePostion();
  }

  void displayRideRequestContainer() {
    setState(() {
      requestHeight = 250;
      rideDetailsHeight = 0;
      bottomMapPadding = 250;
      drawerOpen = true;
    });

    saveRideRequest();
  }

  //
  void displayRideDetailsContainer() async {
    await getPlaceDirection();

    setState(() {
      searcHeight = 0;
      rideDetailsHeight = 230;
      bottomMapPadding = 230;
      drawerOpen = false;
    });
  }

  //
  void locatePostion() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPostion = position;

    LatLng latLngPostion = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPostion, zoom: 18);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await HelperMethods.searchCoordinateAddress(position, context);
    print('ADDRESS: $address');

    initGeoFireLitener();
  }

  //
  static final CameraPosition _ouargla = CameraPosition(
    target: LatLng(31.9527, 5.3335),
    zoom: 14,
  );
  //
  void saveRideRequest() {
    requestRef = FirebaseDatabase.instance.reference().child('rides').push();

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      'lat': pickUp.latitude,
      'long': pickUp.longitude,
    };

    Map dropOffLocMap = {
      'lat': dropOff.latitude,
      'long': dropOff.longitude,
    };
    var price = HelperMethods.calculateFares(tripDirectionDetails);
    Map rideInfo = {
      'payment_method': 'cash',
      'driver_id': 'waiting',
      'distence': tripDirectionDetails.distanceText,
      'duration': tripDirectionDetails.durationText,
      'price': price,
      'pickup': pickUpLocMap,
      'dropoff': dropOffLocMap,
      'created_at': DateTime.now().toString(),
      'rider_name': currentUser.name,
      'rider_phone': currentUser.phone,
      'pickup_address': pickUp.placeName,
      'dropoff_address': dropOff.placeName,
    };

    requestRef.set(rideInfo);
  }

  //
  void cancelRideRequest() {
    requestRef.remove();
  }

  //
  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(36, 36)),
      'assets/images/car_android.png',
    ).then((value) => customIcon = value);
    HelperMethods.getCurrentOnlineUserInfo();
    Provider.of<AppData>(context, listen: false).updateUserData();
  }

  //
  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        key: _scafoldKey,
        drawer: CustomDrawer(appData),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomMapPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
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
                setState(() {
                  bottomMapPadding = 270;
                });
              },
            ),
            //HamburgerButton for Drawer
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  if (drawerOpen) {
                    _scafoldKey.currentState.openDrawer();
                  } else {
                    restApp();
                  }
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
                      drawerOpen ? Icons.menu : Icons.close,
                      color: Colors.black,
                      size: 30,
                    ),
                    radius: 22,
                  ),
                ),
              ),
            ),
            //
            Positioned(
              bottom: bottomMapPadding + 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  locatePostion();
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
                      Icons.location_searching,
                      color: Colors.black,
                      //size: 30,
                    ),
                    radius: 22,
                  ),
                ),
              ),
            ),
            //Search bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: Duration(milliseconds: 160),
                child: Container(
                  height: searcHeight,
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
                              displayRideDetailsContainer();
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
                        SizedBox(height: 19),
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
            ),
            //
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: Duration(milliseconds: 160),
                child: Container(
                  height: rideDetailsHeight,
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
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.tealAccent[100],
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/images/taxi.png', height: 70, width: 80),
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Car',
                                      style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null) ? '${tripDirectionDetails.distanceText}' : ''),
                                      style: TextStyle(fontSize: 18, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  ((tripDirectionDetails != null) ? '${HelperMethods.calculateFares(tripDirectionDetails)} DA' : ''),
                                  style: TextStyle(fontFamily: 'Brand-Bold'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.moneyCheckAlt,
                                size: 18,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 16),
                              Text('Cash'),
                              SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: RaisedButton(
                            onPressed: () {
                              displayRideRequestContainer();
                              availableDrivers = GeoFireHelper.nearbyDriversList;
                              searchNearestDriver();
                            },
                            color: Theme.of(context).accentColor,
                            child: Padding(
                              padding: EdgeInsets.all(17),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.truck,
                                    color: Colors.white,
                                    size: 26,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: requestHeight,
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
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RotateAnimatedTextKit(
                          repeatForever: true,
                          text: [
                            "Requesting a Ride..",
                            "Finding a Driver..",
                            "Please wait.."
                          ],
                          textStyle: TextStyle(fontSize: 30.0, fontFamily: "Brand-Regular"),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    GestureDetector(
                      onTap: () {
                        cancelRideRequest();
                        restApp();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(width: 2, color: Colors.black54),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 26,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Cancel Ride',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                      ),
                    ),
                  ],
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
    setState(() {
      tripDirectionDetails = details;
    });

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
      radius: 8,
      strokeWidth: 4,
      strokeColor: Colors.grey,
      circleId: CircleId('Me'),
    );
    Circle dropOffCircle = Circle(
      fillColor: Colors.black,
      center: dropOffLatLng,
      radius: 8,
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

  void initGeoFireLitener() {
    Geofire.initialize('availableDrivers');
    //

    Geofire.queryAtLocation(currentPostion.latitude, currentPostion.longitude, 1).listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyDrivers nearbyDrivers = NearbyDrivers();
            nearbyDrivers.key = map['key'];
            nearbyDrivers.latitude = map['latitude'];
            nearbyDrivers.longitude = map['longitude'];
            GeoFireHelper.nearbyDriversList.add(nearbyDrivers);
            if (nearbyDriverKeysLoaded) {
              updateDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireHelper.removeDriverFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyDrivers nearbyDrivers = NearbyDrivers();
            nearbyDrivers.key = map['key'];
            nearbyDrivers.latitude = map['latitude'];
            nearbyDrivers.longitude = map['longitude'];
            GeoFireHelper.updateDriverNearbyLocation(nearbyDrivers);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
    //
  }

  void updateDriversOnMap() {
    setState(() {
      markerSet.clear();
    });
    Set<Marker> tMarkers = Set<Marker>();
    for (NearbyDrivers driver in GeoFireHelper.nearbyDriversList) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker marker = Marker(
        markerId: MarkerId("driver${driver.key}"),
        position: driverPosition,
        icon: customIcon,
        //rotation: HelperMethods.createRandomNumber(360),
      );

      tMarkers.add(marker);
    }
    setState(() {
      markerSet = tMarkers;
    });
  }

  void noDriverFound() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NoDriverDialog(),
    );
  }

  void searchNearestDriver() {
    if (availableDrivers.length == 0) {
      cancelRideRequest();
      restApp();
      noDriverFound();
      //displayToatMessage('No available drivers nearby', context);
      return;
    }
    var driver = availableDrivers.first;
    availableDrivers.removeAt(0);
  }
}
