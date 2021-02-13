import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:wasseli/Widgets/button_large.dart';
import 'package:wasseli/tools/color.dart';

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
            icon: SvgPicture.asset(
              'assets/images/close.svg',
              fit: BoxFit.cover,
              color: Colors.white,
              width: 20,
              height: 20,
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
              icon: SvgPicture.asset(
                'assets/images/settings.svg',
                fit: BoxFit.cover,
                color: Colors.white,
                width: 30,
                height: 30,
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
                      height: 108,
                      width: 108,
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
                          'Melkia Mohamed',
                          style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 25),
                        ),
                        SmoothStarRating(
                          color: Color(0xFFFFC107),
                          borderColor: Colors.white,
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
              Row(
                children: [
                  Text(
                    'BALANCE:',
                    style: TextStyle(color: mainTeal, fontSize: 25, fontFamily: 'NexaBold'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '2000 DA',
                    style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'NexaBold'),
                  ),
                ],
              ),
              SizedBox(height: 42),
              Row(
                children: [
                  Text(
                    'EMAIL:',
                    style: TextStyle(color: mainTeal, fontSize: 25, fontFamily: 'NexaBold'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'melkia02@gmail.com',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NexaBold'),
                  ),
                ],
              ),
              SizedBox(height: 42),
              Row(
                children: [
                  Text(
                    'PHONE:',
                    style: TextStyle(color: mainTeal, fontSize: 25, fontFamily: 'NexaBold'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '0779291985',
                    style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'NexaBold'),
                  ),
                ],
              ),
              SizedBox(height: 42),
              Divider(
                color: dviderColor,
              ),
              SizedBox(height: 42),
              CustomLargeButton(title: 'Edit Profile', color: mainTeal, onTap: () {}, titleColor: Colors.white),
              SizedBox(height: 18),
              CustomLargeButton(title: 'Rest Password', color: mainTeal, onTap: () {}, titleColor: Colors.white)
            ],
          ),
        ),
      ),
    );
  }
}
