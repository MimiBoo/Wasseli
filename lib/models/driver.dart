import 'package:firebase_database/firebase_database.dart';

class Driver {
  String key, firstName, lastName, phone, token;
  Map<dynamic, dynamic> carInfo;
  double latitude, longitude, rating;

  Driver({this.key, this.firstName, this.lastName, this.phone, this.carInfo, this.latitude, this.longitude, this.token, this.rating});

  Driver.fromSnapshot(DataSnapshot dataSnapshot, double lat, double long) {
    key = dataSnapshot.key;
    firstName = dataSnapshot.value['first_name'];
    lastName = dataSnapshot.value['last_name'];
    phone = dataSnapshot.value['phone'];
    carInfo = dataSnapshot.value['car_info'];
    token = dataSnapshot.value['token'];
    longitude = long;
    latitude = lat;
    rating = dataSnapshot.value['rating'] == null ? 0 : dataSnapshot.value['rating'];
  }
}
