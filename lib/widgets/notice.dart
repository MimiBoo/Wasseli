import 'package:flutter/material.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';

class Notice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: mainTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Wasseli.warning,
                color: Colors.white,
                size: 37,
              ),
              SizedBox(width: 16),
              Text(
                'NOTICE',
                style: TextStyle(color: Colors.white, fontFamily: 'NexaBold', fontSize: 30),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'this app is in early access so expect bugs and problems',
            style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 22),
          ),
        ],
      ),
    );
  }
}
