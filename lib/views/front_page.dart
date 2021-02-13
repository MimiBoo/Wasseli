import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wasseli/Widgets/button.dart';
import 'package:wasseli/tools/background.dart';
import 'package:wasseli/tools/color.dart';
import 'package:wasseli/views/login.dart';

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
                icon: SvgPicture.asset(
                  'assets/images/language.svg',
                  fit: BoxFit.cover,
                  color: Colors.white,
                  width: 40,
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
