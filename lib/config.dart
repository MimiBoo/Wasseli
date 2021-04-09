import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wasselli/models/ride_details.dart';
import 'package:wasselli/models/users.dart';

String mapKey = 'AIzaSyAP92oJK18rUOmgkzJUBatpGZkTYfdv-X8';
String geoKey = 'AIzaSyC0c81kBdrJIXKAj7sV-kfVtW5DKzkGucw';
String placesKey = 'AIzaSyAMPo9zdAm8KQZmRgg8oR_ay916IqlQ3Do';
String directionKey = 'AIzaSyBuF1e3s6bb1C_ASxLM6vuMmR5_-wR6AWE';
String serverKey = 'key=AAAAifgayTM:APA91bHCu_COvZaRQL8wngyYaA6cl8MV5ay0jgRfCvZi2QZOheKnljyoNlJ3QJqL6fssTmLm_65X0m3okfJOZgP5pA6ZRSPOvKYEWPyaZXD47QjSygyCsIN6W0AXMFe7s4Fx7JzBgAdn';

User currentFirebaseUser;

Position currentPosition;

GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

Users currentUserInfo;
RideDetails rideDetails;
bool isLatin;

int driverRequestTimeout = 60;

double starCounter = 0;
String title = '';
