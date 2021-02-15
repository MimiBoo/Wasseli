import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Helpers/geoFireHelper.dart';
import 'package:wasseli/Helpers/helperMethods.dart';
import 'package:wasseli/Models/directionDetails.dart';
import 'package:wasseli/Screens/search.dart';
import 'package:wasseli/Widgets/collectEarningDialog.dart';
import 'package:wasseli/Widgets/customDrawer.dart';
import 'package:wasseli/Widgets/divder.dart';
import 'package:wasseli/Widgets/noDriversDialog.dart';
import 'package:wasseli/Widgets/progressDialog.dart';
import 'package:wasseli/Models/nearbyDrivers.dart';
import 'package:wasseli/config.dart';
import 'package:wasseli/localization/localization.dart';
import 'package:wasseli/main.dart';
import 'package:wasseli/Screens/rating.dart';

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
  double driverDetailsHeight = 0;

  DirectionDetails tripDirectionDetails;

  DatabaseReference requestRef;
  DatabaseReference availableRef;

  bool drawerOpen = true;
  bool nearbyDriverKeysLoaded = false;

  BitmapDescriptor customIcon;

  List<NearbyDrivers> availableDrivers;

  String state = "normal";

  StreamSubscription<Event> rideStreamSubscription;

  bool isRequestingPositionDetails = false;

  void restApp() {
    setState(() {
      drawerOpen = true;
      searcHeight = 270;
      rideDetailsHeight = 0;
      requestHeight = 0;
      driverDetailsHeight = 0;
      bottomMapPadding = 270;

      polyLinesSet.clear();
      markerSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();

      rideStatus = '';
      driverName = '';
      driverPhone = '';
      carDetails = '';
      driverStatus = 'Driver is coming';
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
      rideDetailsHeight = 240;
      bottomMapPadding = 240;
      drawerOpen = false;
    });
  }

  //
  void displayDriverDetailsContainer() {
    setState(() {
      searcHeight = 0;
      rideDetailsHeight = 0;
      bottomMapPadding = 290;
      driverDetailsHeight = 290;
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
      'rider_id': FirebaseAuth.instance.currentUser.uid,
      'rider_name': currentUser.name,
      'rider_phone': currentUser.phone,
      'pickup_address': pickUp.placeName,
      'dropoff_address': dropOff.placeName,
    };

    requestRef.set(rideInfo);

    rideStreamSubscription = requestRef.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        return;
      }
      if (event.snapshot.value['car_details'] != null) {
        setState(() {
          carDetails = event.snapshot.value['car_details'].toString();
        });
      }
      if (event.snapshot.value['driver_name'] != null) {
        setState(() {
          driverName = event.snapshot.value['driver_name'].toString();
        });
      }
      if (event.snapshot.value['driver_phone'] != null) {
        setState(() {
          driverPhone = event.snapshot.value['driver_phone'].toString();
        });
      }
      if (event.snapshot.value['drivers_location'] != null) {
        double driverLat = event.snapshot.value['drivers_location']['lat'];
        double driverLng = event.snapshot.value['drivers_location']['long'];
        LatLng driverCurrentPos = LatLng(driverLat, driverLng);
        if (rideStatus == 'accepted') {
          updateRideTimeToPickUp(driverCurrentPos);
        } else if (rideStatus == 'ongoing') {
          updateRideTimeToDropOff(driverCurrentPos);
        } else if (rideStatus == 'arrived') {
          setState(() {
            driverStatus = 'Driver has Arrived';
          });
        }
      }
      if (event.snapshot.value['status'] != null) {
        rideStatus = event.snapshot.value['status'];
      }
      if (rideStatus == 'accepted') {
        displayDriverDetailsContainer();
        Geofire.stopListener();
        deleteGeoFireMarkers();
      }
      if (rideStatus == 'ended') {
        if (event.snapshot.value['price'] != null) {
          int price = event.snapshot.value['price'];
          var res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CollectEarningDialog(price: price),
          );
          String driverId = '';
          if (res == 'close') {
            if (event.snapshot.value['driver_id'] != null) {
              driverId = event.snapshot.value['driver_id'];
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RatingScreen(
                  driverId: driverId,
                  rideId: event.snapshot.key,
                ),
              ),
            );
            requestRef.onDisconnect();
            requestRef = null;
            rideStreamSubscription.cancel();
            rideStreamSubscription = null;
            restApp();
          }
        }
      }
    });
  }

  //
  void deleteGeoFireMarkers() {
    setState(() {
      markerSet.removeWhere((element) => element.markerId.value.contains('driver'));
    });
  }

  //
  void updateRideTimeToDropOff(LatLng driverCurrentPos) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
      var dropOffLatLng = LatLng(dropOff.latitude, dropOff.longitude);
      var details = await HelperMethods.obtainDirectionsDetails(driverCurrentPos, dropOffLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        driverStatus = 'Going to destination - ${details.durationText}';
      });
      isRequestingPositionDetails = false;
    }
  }

  //
  void updateRideTimeToPickUp(LatLng driverCurrentPos) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;
      var userPositionLatLng = LatLng(currentPostion.latitude, currentPostion.longitude);
      var details = await HelperMethods.obtainDirectionsDetails(driverCurrentPos, userPositionLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        driverStatus = 'Driver is coming - ${details.durationText}';
      });
      isRequestingPositionDetails = false;
    }
  }

  //
  void cancelRideRequest() {
    requestRef.remove();
    setState(() {
      state = 'normal';
    });
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
    var lang = DemoLocalization.of(context);
    Locale myLocale = Localizations.localeOf(context);
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
                if (_googleMapController == null) _googleMapController.complete(controller);
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
              left: myLocale.languageCode == 'en' ? 10 : null,
              right: myLocale.languageCode == 'ar' ? 10 : null,
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
              left: myLocale.languageCode == 'en' ? null : 10,
              right: myLocale.languageCode == 'ar' ? null : 10,
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
            //Search panel
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Text(
                          lang.getTranslatedValue('greating'),
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          lang.getTranslatedValue('where_to'),
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
                                  Text(lang.getTranslatedValue('search')),
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
                                  Provider.of<AppData>(context).pickUpLocation != null ? Provider.of<AppData>(context).pickUpLocation.placeName : lang.getTranslatedValue('add_home'),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  lang.getTranslatedValue('home_address'),
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
                                Text(lang.getTranslatedValue('add_work')),
                                SizedBox(height: 4),
                                Text(
                                  lang.getTranslatedValue('work_address'),
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
            //Order panel
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
                                Image.asset('assets/images/truck.png', height: 70, width: 80),
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.getTranslatedValue('mini_truck'),
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
                                  ((tripDirectionDetails != null) ? '${HelperMethods.calculateFares(tripDirectionDetails)} ${lang.getTranslatedValue('currency')}' : ''),
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
                              Text(lang.getTranslatedValue('payment_method')),
                              SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                state = 'requesting';
                              });
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
                                    lang.getTranslatedValue('order_button'),
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
            //Waiting panel
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
                            lang.getTranslatedValue('wait_msg_1'),
                            lang.getTranslatedValue('wait_msg_2'),
                            lang.getTranslatedValue('wait_msg_3'),
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
                        lang.getTranslatedValue('cancel_button'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Driver info panel
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: driverDetailsHeight,
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
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            driverStatus,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      Text(
                        carDetails,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        driverName,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 22),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //call
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                launch('tel://$driverPhone');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(26)),
                                      border: Border.all(width: 2, color: Colors.grey),
                                    ),
                                    child: Icon(
                                      Icons.call,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(lang.getTranslatedValue('call_button')),
                                ],
                              ),
                            ),
                          ),
                          //details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(26)),
                                  border: Border.all(width: 2, color: Colors.grey),
                                ),
                                child: Icon(
                                  Icons.list,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(lang.getTranslatedValue('details_button'))
                            ],
                          ),
                          //cancel
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                cancelRideRequest();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(26)),
                                      border: Border.all(width: 2, color: Colors.grey),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(lang.getTranslatedValue('cancel_button')),
                                ],
                              ),
                            ),
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
    });
    //
  }

  void updateDriversOnMap() {
    if (this.mounted) {
      setState(() {
        markerSet.clear();
      });
    }

    Set<Marker> tMarkers = Set<Marker>();
    for (NearbyDrivers driver in GeoFireHelper.nearbyDriversList) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker marker = Marker(
        markerId: MarkerId("driver${driver.key}"),
        position: driverPosition,
        icon: customIcon,
      );

      tMarkers.add(marker);
    }
    if (this.mounted) {
      setState(() {
        markerSet = tMarkers;
      });
    }
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
    notifyDriver(driver);
    availableDrivers.removeAt(0);
  }

  void notifyDriver(NearbyDrivers driver) {
    driverRef.child(driver.key).child('newRide').set(requestRef.key);
    driverRef.child(driver.key).child('token').once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String token = snapshot.value.toString();
        HelperMethods.sendNotificationToDriver(token, context, requestRef.key);
      } else {
        return;
      }
      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
        if (state != 'requesting') {
          driverRef.child(driver.key).child('newRide').set('cancelled');
          driverRef.child(driver.key).child('newRide').onDisconnect();
          driverRequestTimeout = 60;
          timer.cancel();
        }

        driverRequestTimeout -= 1;
        driverRef.child(driver.key).child('newRide').onValue.listen((event) {
          if (event.snapshot.value.toString() == 'accepted') {
            driverRef.child(driver.key).child('newRide').onDisconnect();
            driverRequestTimeout = 60;
            timer.cancel();
          }
        });

        if (driverRequestTimeout == 0) {
          driverRef.child(driver.key).child('newRide').set('timeout');
          driverRef.child(driver.key).child('newRide').onDisconnect();
          driverRequestTimeout = 60;
          timer.cancel();
          searchNearestDriver();
        }
      });
    });
  }
}
