import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';
import 'package:wasselli/views/front_page.dart';
import 'package:wasselli/widgets/button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainBlack,
        appBar: AppBar(
          backgroundColor: mainBlack,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Wasseli.close,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Account Information',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'NexaLight',
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Wasseli.settings,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 64),
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/user_icon.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${currentUserInfo.firstName} ${currentUserInfo.lastName}",
                          style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 25),
                        ),
                        SmoothStarRating(
                          rating: currentUserInfo.rating,
                          color: Color(0xFFFFC107),
                          borderColor: Colors.white,
                          isReadOnly: true,
                          starCount: 5,
                          allowHalfRating: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
              Divider(
                color: dviderColor,
              ),
              SizedBox(height: 35),
              // Row(
              //   children: [
              //     Text(
              //       'BALANCE:',
              //       style: TextStyle(color: mainTeal, fontSize: 25, fontFamily: 'NexaBold'),
              //     ),
              //     SizedBox(width: 10),
              //     Text(
              //       '2000 DA',
              //       style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'NexaBold'),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 42),
              // Row(
              //   children: [
              //     Text(
              //       'EMAIL:',
              //       style: TextStyle(color: mainTeal, fontSize: 25, fontFamily: 'NexaBold'),
              //     ),
              //     SizedBox(width: 10),
              //     Text(
              //       'melkia02@gmail.com',
              //       style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NexaBold'),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 42),
              Row(
                children: [
                  Text(
                    'PHONE:',
                    style: TextStyle(color: mainTeal, fontSize: 20, fontFamily: 'NexaBold'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    currentUserInfo.phone,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NexaBold'),
                  ),
                ],
              ),
              SizedBox(height: 42),
              Divider(
                color: dviderColor,
              ),
              SizedBox(height: 42),
              CustomButton(title: 'Edit Profile', color: mainTeal, onTap: () {}, titleColor: Colors.white),
              SizedBox(height: 18),
              CustomButton(
                  title: 'Sign Out',
                  color: Colors.red,
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => FrontPage()));
                  },
                  titleColor: Colors.white)
            ],
          ),
        ),
      ),
    );
  }
}
