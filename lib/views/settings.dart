import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wasseli/Widgets/notice.dart';
import 'package:wasseli/tools/color.dart';

class SettingsScreen extends StatelessWidget {
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
              'assets/images/previous.svg',
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
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'NexaLight',
              fontSize: 30,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 47),
                child: Notice(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23, bottom: 47),
                child: Divider(
                  color: dviderColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change Language',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  DropdownButton(
                    underline: SizedBox(width: 0),
                    icon: SvgPicture.asset(
                      'assets/images/language.svg',
                      fit: BoxFit.cover,
                      color: Colors.white,
                      width: 35,
                      height: 35,
                    ),
                    items: [
                      DropdownMenuItem(child: Container(color: Colors.amber)),
                      DropdownMenuItem(child: Container(color: Colors.amber)),
                    ],
                    onChanged: (val) {},
                  ),
                ],
              ),
              SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notification',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  IconButton(
                      icon: RotationTransition(
                        turns: new AlwaysStoppedAnimation(180 / 360),
                        child: SvgPicture.asset(
                          'assets/images/previous.svg',
                          fit: BoxFit.cover,
                          color: Colors.white,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      onPressed: () {})
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 47),
                child: Divider(
                  color: dviderColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About Us',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  IconButton(
                      icon: RotationTransition(
                        turns: new AlwaysStoppedAnimation(180 / 360),
                        child: SvgPicture.asset(
                          'assets/images/previous.svg',
                          fit: BoxFit.cover,
                          color: Colors.white,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      onPressed: () {})
                ],
              ),
              SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  IconButton(
                      icon: RotationTransition(
                        turns: new AlwaysStoppedAnimation(180 / 360),
                        child: SvgPicture.asset(
                          'assets/images/previous.svg',
                          fit: BoxFit.cover,
                          color: Colors.white,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      onPressed: () {})
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
