import 'package:firebase_database/firebase_database.dart';

class Users {
  String id;
  String firstName;
  String lastName;
  String phone;

  Users({this.id, this.firstName, this.lastName, this.phone});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    firstName = dataSnapshot.value['first_name'];
    lastName = dataSnapshot.value['last_name'];
    phone = dataSnapshot.value['phone'];
  }
}
