import 'package:firebase_database/firebase_database.dart';

class Users {
  String id;
  String email;
  String name;
  String phone;

  Users({this.id, this.name, this.email, this.phone});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value['email'];
    name = dataSnapshot.value['name'];
    phone = dataSnapshot.value['phone'];
  }
}
