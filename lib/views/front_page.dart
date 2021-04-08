import 'package:flutter/material.dart';
import 'package:wasselli/Widgets/button.dart';
import 'package:wasselli/tools/background.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';
import 'package:wasselli/views/login.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            BackgroundBlur(),
            //App title
            Positioned(
              top: 74,
              left: 25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome to',
                    style: TextStyle(color: Colors.white, fontFamily: "Nirmala", fontSize: 30),
                  ),
                  Text(
                    'Wasseli',
                    style: TextStyle(color: Colors.white, fontFamily: "MS", fontSize: 85),
                  ),
                ],
              ),
            ),
            //Authenticate button
            Positioned(
              bottom: 160,
              left: 96.5,
              child: Column(
                children: [
                  CustomButton(
                    title: 'Authenticate',
                    titleColor: mainTeal,
                    color: Colors.white,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                  )
                ],
              ),
            ),
            //Language dropdown button
            Positioned(
              bottom: 86,
              left: 176.5,
              child: DropdownButton(
                underline: SizedBox(width: 0),
                icon: Icon(
                  Wasseli.language,
                  color: Colors.white,
                  size: 40,
                ),
                items: [
                  DropdownMenuItem(child: Container(color: Colors.amber)),
                  DropdownMenuItem(child: Container(color: Colors.amber)),
                ],
                onChanged: (val) {},
              ),
            ),
            //copyright
            Positioned(
              bottom: 2,
              left: 149,
              child: Text(
                'wasseli©2021',
                style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
