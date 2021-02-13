import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wasseli/tools/color.dart';
import 'package:wasseli/views/home.dart';

class LocationItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
          },
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/pin.svg',
                      fit: BoxFit.cover,
                      color: mainTeal,
                      width: 30,
                    ),
                    Text(
                      'Ecole Normale Supérieure',
                      style: TextStyle(color: mainBlack, fontFamily: 'NexaLight', fontSize: 20),
                    ),
                  ],
                ),
                IconButton(
                    icon: RotationTransition(
                      turns: new AlwaysStoppedAnimation(180 / 360),
                      child: SvgPicture.asset(
                        'assets/images/previous.svg',
                        fit: BoxFit.cover,
                        color: mainBlack,
                        width: 30,
                      ),
                    ),
                    onPressed: null)
              ],
            ),
          ),
        ),
        Divider(
          color: dviderColor,
          thickness: 1,
        ),
      ],
    );
  }
}
