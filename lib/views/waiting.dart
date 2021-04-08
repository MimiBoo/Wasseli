import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/main.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/views/home.dart';
import 'package:wasselli/widgets/button.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;

  static final CameraPosition _position = CameraPosition(
    target: LatLng(currentPosition.latitude, currentPosition.longitude),
    zoom: 18,
  );

  String status = 'waiting';
  void updateStatus() {
    requestRef.onChildChanged.listen((event) {
      if (status == "accepted") {
        userRef.child(currentFirebaseUser.uid).child("history").child("${DateTime.now().month}-${DateTime.now().year}").child(requestRef.key).set(DateTime.now().toString());
      } else if (status == "canceled") {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (Route<dynamic> route) => false);
      } else if (status == "declined") {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (Route<dynamic> route) => false);
      }
      setState(() {
        status = event.snapshot.value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainBlack,
          title: Text(
            'Ongoing Ride',
            style: TextStyle(fontFamily: 'NexaLight', fontSize: 20),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: status == "accepted"
            ? Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    compassEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    // polylines: polyLineSet,
                    // markers: markersSet,
                    // circles: circlesSet,
                    initialCameraPosition: _position,
                    onMapCreated: (GoogleMapController controller) async {
                      if (_googleMapController == null) _googleMapController.complete(controller);
                      newGoogleMapController = controller;
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      //height: 80,
                      decoration: BoxDecoration(color: mainBlack, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            rideDetails.duration,
                            style: TextStyle(color: mainTeal, fontFamily: "NexaBold", fontSize: 18),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 67,
                                width: 67,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xffd4d4d4),
                                ),
                                child: Image.asset(
                                  'assets/images/user_icon.png',
                                ),
                              ),
                              Flexible(
                                child: FractionallySizedBox(
                                  widthFactor: 0.1,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rideDetails.driverName,
                                    style: TextStyle(color: Colors.white, fontFamily: "NexaBold", fontSize: 18),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    rideDetails.driverPhone,
                                    style: TextStyle(color: Colors.white, fontFamily: "NexaLight", fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StepsIndicator(
                                selectedStep: 2,
                                doneLineColor: mainTeal,
                                doneStepColor: mainTeal,
                                nbSteps: 2,
                                isHorizontal: false,
                                lineLengthCustomStep: [
                                  StepsIndicatorCustomLine(nbStep: 2, length: 100)
                                ],
                              ),
                              SizedBox(width: 6),
                              Flexible(
                                child: Container(
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'From',
                                                style: TextStyle(fontFamily: 'NexaLight', fontSize: 14, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            rideDetails.pickUpAddress,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'NexaBold',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'To',
                                            style: TextStyle(fontFamily: 'NexaLight', fontSize: 14, color: Colors.grey),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            rideDetails.dropOffAddress,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'NexaBold',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    requestRef.child("status").set("canceled");
                                  },
                                  child: Container(
                                    // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width),
                                    height: 53,
                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "NexaBold"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    launch("tel:${rideDetails.driverPhone}");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
                                    height: 53,
                                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   'Ongoing Ride',
                          //   style: TextStyle(fontFamily: 'NexaLight', fontSize: 20, color: Colors.white),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : status == "ended"
                ? RatingScreen()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TyperAnimatedTextKit(
                            alignment: Alignment.center,
                            text: [
                              "Waiting For Driver",
                            ],
                            textStyle: TextStyle(fontSize: 30.0, fontFamily: "Bobbers"),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      )
                    ],
                  ),
      ),
    );
  }
}

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 0;

  int step = 1;

  @override
  Widget build(BuildContext context) {
    return step == 1
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 22),
                  Text(
                    'Cash Payment',
                    style: TextStyle(color: mainBlack, fontFamily: 'NexaBold', fontSize: 22),
                  ),
                  SizedBox(height: 22),
                  Divider(color: Colors.grey),
                  SizedBox(height: 16),
                  Text("${rideDetails.price} DA", style: TextStyle(fontSize: 55, fontFamily: 'NexaBold', color: mainBlack)),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('This is the trip price.', style: TextStyle(fontFamily: 'NexaBold', color: Colors.grey), textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        step = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
                      height: 53,
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Collect Cash',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontFamily: 'NexaBold', fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rate This Trip',
                    style: TextStyle(fontFamily: 'NexaBold', fontSize: 20),
                  ),
                  SizedBox(height: 28),
                  SmoothStarRating(
                    color: Color(0xFFFFC107),
                    borderColor: mainBlack,
                    starCount: 5,
                    allowHalfRating: false,
                    size: 50,
                    onRated: (value) {
                      rating = value;
                    },
                  ),
                  SizedBox(height: 28),
                  CustomButton(
                    color: mainTeal,
                    onTap: () {
                      rateDriver(context, rating);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (Route<dynamic> route) => false);
                    },
                    title: "Rate",
                    titleColor: Colors.white,
                  )
                ],
              ),
            ),
          );
  }

  void rateDriver(BuildContext context, double rating) async {
    var driver = Provider.of<AppData>(context, listen: false).selecteDriver;
    var snap = await driverRef.child(driver.key).child("rating").once();
    if (snap.value != null) {
      double oldRating = snap.value.toDouble();
      double newRating = (rating + oldRating) / 2;
      await driverRef.child(driver.key).child("rating").set(newRating);
    } else {
      await driverRef.child(driver.key).child("rating").set(rating);
    }
  }
}
