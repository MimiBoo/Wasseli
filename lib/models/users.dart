import 'package:firebase_database/firebase_database.dart';

class Users {
  String key, firstName, lastName, phone;
  double rating;

  Users({this.key, this.firstName, this.lastName, this.phone, this.rating});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    key = dataSnapshot.key;
    firstName = dataSnapshot.value['first_name'];
    lastName = dataSnapshot.value['last_name'];
    phone = dataSnapshot.value['phone'];
    rating = dataSnapshot.value['rating'] == null ? 0.0 : dataSnapshot.value['rating'].toDouble();
  }
}
