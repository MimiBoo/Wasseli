import 'package:firebase_database/firebase_database.dart';

class Driver {
  String key, firstName, lastName, phone, token;
  Map<dynamic, dynamic> carInfo;
  double latitude, longitude;

  Driver({this.key, this.firstName, this.lastName, this.phone, this.carInfo, this.latitude, this.longitude, this.token});

  Driver.fromSnapshot(DataSnapshot dataSnapshot) {
    key = dataSnapshot.key;
    firstName = dataSnapshot.value['first_name'];
    lastName = dataSnapshot.value['last_name'];
    phone = dataSnapshot.value['phone'];
    carInfo = dataSnapshot.value['car_info'];
    token = dataSnapshot.value['token'];
  }
}
