import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasseli/tools/color.dart';
import 'package:wasseli/views/front_page.dart';
import 'package:wasseli/views/order.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            GestureDetector(
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
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
            onPressed: () {},
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
            height: 70,
            color: mainBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/menu.svg',
                      fit: BoxFit.cover,
                      color: Colors.white,
                      width: 40,
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => FrontPage()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/profile.svg',
                      fit: BoxFit.cover,
                      color: Colors.white,
                      width: 40,
                    ),
                    onPressed: () {
                      //Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
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
}
