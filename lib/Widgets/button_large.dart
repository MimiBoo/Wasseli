import 'package:flutter/material.dart';

class CustomLargeButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color color;
  final Function onTap;

  const CustomLargeButton({@required this.title, @required this.color, @required this.onTap, @required this.titleColor});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 53,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: titleColor, fontSize: 25, fontFamily: "NexaLight"),
          ),
        ),
      ),
    );
  }
}
